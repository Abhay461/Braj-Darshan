import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/ad_banner_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredTemplesProvider);
    final allTemplesAsync = ref.watch(allTemplesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.temple_hindu_outlined, size: 22, color: Color(0xFF18181B)),
            SizedBox(width: 8),
            Text(
              'Braj Darshan',
              style: TextStyle(
                color: Color(0xFF18181B),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined, color: Color(0xFF18181B)),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, color: Color(0xFF18181B)),
            onPressed: () => context.push('/map'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Color(0xFF18181B)),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF18181B)),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF18181B),
        onRefresh: () async {
          ref.refresh(featuredTemplesProvider);
          ref.refresh(allTemplesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP SECTION: Featured Temples Auto-Scrolling Carousel (with Images)
              featuredAsync.when(
                data: (featuredList) => FeaturedTemplesCarousel(
                  temples: featuredList,
                  onTap: (temple) => context.push('/temple/${temple.id}'),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: LoadingSkeleton(height: 175),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ErrorView(
                    message: 'Failed to load featured shrines',
                    onRetry: () => ref.refresh(featuredTemplesProvider),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 2. BOTTOM SECTION: Complete Temple List (Compact Text-Only Layout)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Temples',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF18181B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    allTemplesAsync.when(
                      data: (list) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE4E4E7)),
                        ),
                        child: Text(
                          '${list.length} Shrines',
                          style: const TextStyle(
                            color: Color(0xFF71717A),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: allTemplesAsync.when(
                  data: (temples) {
                    if (temples.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'No temples found',
                            style: TextStyle(color: Color(0xFF71717A)),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: temples
                          .map((temple) => TempleCard(
                                temple: temple,
                                showImage: false,
                                heroTag: 'all_${temple.id}',
                                onTap: () => context.push('/temple/${temple.id}'),
                              ))
                          .toList(),
                    ).animate().fadeIn(duration: 300.ms);
                  },
                  loading: () => const Column(
                    children: [
                      LoadingSkeleton(height: 55),
                      SizedBox(height: 8),
                      LoadingSkeleton(height: 55),
                      SizedBox(height: 8),
                      LoadingSkeleton(height: 55),
                      SizedBox(height: 8),
                      LoadingSkeleton(height: 55),
                    ],
                  ),
                  error: (err, _) => ErrorView(
                    message: 'Failed to load temple list',
                    onRetry: () => ref.refresh(allTemplesProvider),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: AdBannerWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Featured Temples Auto-Scrolling Carousel (Smooth right-to-left infinite loop)
// ---------------------------------------------------------------------------
class FeaturedTemplesCarousel extends StatefulWidget {
  final List<Temple> temples;
  final Function(Temple) onTap;

  const FeaturedTemplesCarousel({
    super.key,
    required this.temples,
    required this.onTap,
  });

  @override
  State<FeaturedTemplesCarousel> createState() => _FeaturedTemplesCarouselState();
}

class _FeaturedTemplesCarouselState extends State<FeaturedTemplesCarousel> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 1000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.9,
    );
    if (widget.temples.isNotEmpty) {
      _startAutoScroll();
    }
  }

  @override
  void didUpdateWidget(covariant FeaturedTemplesCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.temples.isNotEmpty && (_autoScrollTimer == null || !_autoScrollTimer!.isActive)) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && widget.temples.isNotEmpty) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 750),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.temples.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Temples',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF18181B),
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF18181B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'FEATURED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 185,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              _currentPage = index;
            },
            itemBuilder: (context, index) {
              final temple = widget.temples[index % widget.temples.length];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_pageController.position.haveDimensions) {
                    double pageOffset = (_pageController.page ?? _currentPage.toDouble()) - index;
                    scale = (1 - (pageOffset.abs() * 0.06)).clamp(0.94, 1.0);
                  }
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: TempleCard(
                    temple: temple,
                    showImage: true,
                    imageHeight: 120,
                    heroTag: 'featured_${temple.id}_$index',
                    onTap: () => widget.onTap(temple),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
