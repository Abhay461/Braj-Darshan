import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/ad_banner_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategoryId;

  void _openNearbyHotels() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/hotels+near+vrindavan');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final featuredAsync = ref.watch(featuredTemplesProvider);
    final allTemplesAsync = ref.watch(allTemplesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      // Left Hamburger Navigation Drawer
      drawer: Drawer(
        backgroundColor: isDark ? const Color(0xFF141417) : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.temple_hindu_outlined,
                        size: 26,
                        color: isDark ? Colors.white : const Color(0xFF18181B),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Braj Darshan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF18181B),
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Spiritual Guide v2.0',
                          style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Drawer Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.map_outlined, size: 22),
                      title: const Text('Interactive Map', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/map');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.hotel_outlined, size: 22),
                      title: const Text('Nearby Hotels', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        _openNearbyHotels();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline, size: 22),
                      title: const Text('Saved Favorites', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/favorites');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.event_outlined, size: 22),
                      title: const Text('Festivals & Utsavs', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/festivals');
                      },
                    ),
                    Divider(height: 24, color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7)),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, size: 22),
                      title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/settings');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Navigation Menu',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(Icons.menu, color: isDark ? Colors.white : const Color(0xFF18181B)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Braj Darshan',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF18181B),
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(Icons.search_outlined, color: isDark ? Colors.white : const Color(0xFF18181B)),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: isDark ? Colors.white : const Color(0xFF18181B),
        onRefresh: () async {
          ref.refresh(featuredTemplesProvider);
          ref.refresh(allTemplesProvider);
          ref.refresh(categoriesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP SECTION: Featured Temples Auto-Scrolling Carousel (Image-Only Mode)
              featuredAsync.when(
                data: (featuredList) => FeaturedTemplesCarousel(
                  temples: featuredList,
                  onTap: (temple) => context.push('/temple/${temple.id}'),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: LoadingSkeleton(height: 185),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ErrorView(
                    message: 'Failed to load featured temples',
                    onRetry: () => ref.refresh(featuredTemplesProvider),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Horizontal Category Chips Bar
              categoriesAsync.when(
                data: (categories) => SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected = _selectedCategoryId == null;
                        return FilterChip(
                          selected: isSelected,
                          showCheckmark: false,
                          label: const Text('All Temples'),
                          selectedColor: isDark ? Colors.white : const Color(0xFF18181B),
                          backgroundColor: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark ? Colors.white : const Color(0xFF18181B)),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) {
                            setState(() => _selectedCategoryId = null);
                          },
                        );
                      }
                      final cat = categories[index - 1];
                      final isSelected = _selectedCategoryId == cat.id;
                      return FilterChip(
                        selected: isSelected,
                        showCheckmark: false,
                        label: Text(cat.name),
                        selectedColor: isDark ? Colors.white : const Color(0xFF18181B),
                        backgroundColor: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark ? Colors.white : const Color(0xFF18181B)),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setState(() => _selectedCategoryId = cat.id);
                        },
                      );
                    },
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: LoadingSkeleton(height: 38),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              // 2. BOTTOM SECTION: Complete Temple List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Temples',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF18181B),
                        letterSpacing: -0.4,
                      ),
                    ),
                    allTemplesAsync.when(
                      data: (list) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                          ),
                        ),
                        child: Text(
                          '${list.length} Temples',
                          style: TextStyle(
                            color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
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
                    var filteredList = temples;
                    if (_selectedCategoryId != null) {
                      filteredList = temples.where((t) {
                        final catId = t.category is Category
                            ? (t.category as Category).id
                            : (t.category is Map ? t.category['_id'] ?? '' : t.category?.toString() ?? '');
                        return catId == _selectedCategoryId;
                      }).toList();
                    }

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No temples found in this category',
                            style: TextStyle(color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A)),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: filteredList
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
// Featured Temples Auto-Scrolling Carousel (Image-Only Cards)
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

    return SizedBox(
      height: 180,
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
                showDetails: false, // SIRF IMAGE DIKHNA CHAHIYE!
                imageHeight: 180,
                heroTag: 'featured_${temple.id}_$index',
                onTap: () => widget.onTap(temple),
              ),
            ),
          );
        },
      ),
    );
  }
}
