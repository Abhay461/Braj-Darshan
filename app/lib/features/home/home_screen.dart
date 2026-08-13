import 'dart:async';
// ignore_for_file: avoid_unused_result, unused_result
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/ad_banner_widget.dart';
import '../../core/localization/app_translations.dart';
import '../../core/theme/app_theme.dart';

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

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('all')) return Icons.grid_view_outlined;
    if (name.contains('shrine') || name.contains('temple') || name.contains('mandir')) return Icons.temple_hindu_outlined;
    if (name.contains('dham') || name.contains('ghat') || name.contains('place')) return Icons.place_outlined;
    if (name.contains('heritage') || name.contains('history')) return Icons.history_edu_outlined;
    if (name.contains('utsav') || name.contains('festival')) return Icons.event_outlined;
    return Icons.auto_awesome_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLang = ref.watch(appLanguageProvider);
    final featuredAsync = ref.watch(featuredTemplesProvider);
    final popularAsync = ref.watch(popularTemplesProvider);
    final allTemplesAsync = ref.watch(allTemplesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return SafeArea(
      top: true,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Drawer Header Container (Light Golden Theme)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF2C2411), const Color(0xFF1E180A)]
                          : [const Color(0xFFFFF7E6), const Color(0xFFFDE8B5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFD4AF37).withOpacity( 0.4),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity( 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.temple_hindu_outlined,
                          size: 32,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Braj Darshan',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore Sacred Dham Shrines',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      Semantics(
                        label: 'Navigate to Home',
                        button: true,
                        child: ListTile(
                          leading: const Icon(Icons.home_outlined, size: 22),
                          title: Text(
                            AppTranslations.getText(currentLang, 'home'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Semantics(
                        label: 'Navigate to Search Shrines',
                        button: true,
                        child: ListTile(
                          leading: const Icon(Icons.search_outlined, size: 22),
                          title: Text(
                            AppTranslations.getText(currentLang, 'search_shrines'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            context.push('/search');
                          },
                        ),
                      ),
                      Semantics(
                        label: 'Navigate to Saved Favorites',
                        button: true,
                        child: ListTile(
                          leading: const Icon(Icons.favorite_border, size: 22),
                          title: Text(
                            AppTranslations.getText(currentLang, 'saved_favorites'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            context.push('/favorites');
                          },
                        ),
                      ),
                      Semantics(
                        label: 'Navigate to Festivals',
                        button: true,
                        child: ListTile(
                          leading: const Icon(Icons.event_outlined, size: 22),
                          title: Text(
                            AppTranslations.getText(currentLang, 'festivals'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            context.push('/festivals');
                          },
                        ),
                      ),
                      Semantics(
                        label: 'Navigate to Interactive Map',
                        button: true,
                        child: ListTile(
                          leading: const Icon(Icons.map_outlined, size: 22),
                          title: Text(
                            AppTranslations.getText(currentLang, 'interactive_map'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            context.push('/map');
                          },
                        ),
                      ),
                      Semantics(
                        label: 'Open Nearby Hotels',
                        button: true,
                        child: ListTile(
                          leading: const Icon(Icons.hotel_outlined, size: 22),
                          title: Text(
                            AppTranslations.getText(currentLang, 'nearby_hotels'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            _openNearbyHotels();
                          },
                        ),
                      ),
                      Semantics(
                        label: 'Navigate to Yatra Planner',
                        button: true,
                        child: ListTile(
                          leading: const Icon(Icons.calendar_month_outlined, size: 22),
                          title: Text(
                            'My Yatra Planner',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            context.push('/yatra-planner');
                          },
                        ),
                      ),
                      ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        leading: const Icon(Icons.language_outlined, size: 22),
                        title: Text(
                          AppTranslations.getText(currentLang, 'language'),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          currentLang == 'hi' ? 'हिंदी (Hindi)' : 'English',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                          ),
                        ),
                        children: [
                          RadioGroup<String>(
                            groupValue: currentLang,
                            onChanged: (val) {
                              if (val != null) {
                                HapticFeedback.selectionClick();
                                ref.read(appLanguageProvider.notifier).setLanguage(val);
                              }
                            },
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  contentPadding: const EdgeInsets.only(left: 32, right: 16),
                                  title: Text('English', style: Theme.of(context).textTheme.labelLarge),
                                  value: 'en',
                                  fillColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),
                                ),
                                RadioListTile<String>(
                                  contentPadding: const EdgeInsets.only(left: 32, right: 16),
                                  title: Text('हिंदी (Hindi)', style: Theme.of(context).textTheme.labelLarge),
                                  value: 'hi',
                                  fillColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline, size: 22),
                        title: Text(
                          AppTranslations.getText(currentLang, 'about_app'),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          'v2.0 • Braj Darshan',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                          ),
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          showAboutDialog(
                            context: context,
                            applicationName: 'Braj Darshan',
                            applicationVersion: '2.0.0',
                            applicationIcon: const Icon(Icons.temple_hindu, size: 36, color: AppTheme.secondaryIndigo),
                            children: const [
                              Text('Spiritual Guide for Vrindavan, Mathura & Braj Dham.'),
                            ],
                          );
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: Builder(
            builder: (context) => IconButton(
              tooltip: 'Navigation Menu',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () {
                HapticFeedback.lightImpact();
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text(
            AppTranslations.getText(currentLang, 'app_title'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            IconButton(
              tooltip: AppTranslations.getText(currentLang, 'search_shrines'),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(Icons.search_outlined, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push('/search');
              },
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const AdBannerWidget(),
          ),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          onRefresh: () async {
            ref.refresh(featuredTemplesProvider);
            ref.refresh(allTemplesProvider);
            ref.refresh(categoriesProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Featured Carousel
                featuredAsync.when(
                  data: (featuredList) => FeaturedTemplesCarousel(
                    temples: featuredList,
                    onTap: (temple) {
                      HapticFeedback.lightImpact();
                      context.push('/temple/${temple.id}');
                    },
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: LoadingSkeleton(height: 200),
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

                // 2. Top Destinations Section (Horizontal Cards)
                popularAsync.when(
                  data: (popularList) => TopDestinationsSection(
                    temples: popularList,
                    onTap: (temple) {
                      HapticFeedback.lightImpact();
                      context.push('/temple/${temple.id}');
                    },
                    onViewAll: () {
                      HapticFeedback.lightImpact();
                      context.push('/search');
                    },
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: LoadingSkeleton(height: 136),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // 3. Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    AppTranslations.getText(currentLang, 'all_temples'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),

                const SizedBox(height: 12),

                // Temple List View (Lazy Rendered)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: allTemplesAsync.when(
                    data: (temples) {
                      var filteredList = temples;
                      if (_selectedCategoryId != null) {
                        filteredList = temples.where((t) {
                          final catId = t.category is Category
                              ? (t.category as Category).id
                              : (t.category is Map ? (t.category['_id'] ?? t.category['id'] ?? '') : t.category?.toString() ?? '');
                          return catId == _selectedCategoryId;
                        }).toList();
                      }

                      if (filteredList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'No temples found',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final temple = filteredList[index];
                          return TempleCard(
                            temple: temple,
                            showImage: false,
                            heroTag: 'all_${temple.id}',
                            onTap: () {
                              HapticFeedback.lightImpact();
                              context.push('/temple/${temple.id}');
                            },
                          );
                        },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Featured Temples Auto-Scrolling Carousel
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
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.92,
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
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && widget.temples.isNotEmpty) {
        _currentPage = (_currentPage + 1) % widget.temples.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
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

    final activeIndex = _currentPage % widget.temples.length;

    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.temples.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index % widget.temples.length);
            },
            itemBuilder: (context, index) {
              final temple = widget.temples[index];

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => widget.onTap(temple),
                    borderRadius: BorderRadius.circular(20),
                    child: Semantics(
                      label: temple.name,
                      image: true,
                      child: CachedNetworkImage(
                        imageUrl: temple.coverImage.isNotEmpty
                            ? temple.coverImage
                            : (temple.thumbnailImage ?? 'https://via.placeholder.com/600'),
                        height: 195,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: Theme.of(context).colorScheme.surface),
                        errorWidget: (_, __, ___) => Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: Icon(Icons.temple_hindu_outlined, size: 40, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.temples.length,
            (idx) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: activeIndex == idx ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: activeIndex == idx
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Top Destinations Section — Horizontal Card Scroll
// ---------------------------------------------------------------------------
class TopDestinationsSection extends StatelessWidget {
  final List<Temple> temples;
  final Function(Temple) onTap;
  final VoidCallback onViewAll;

  const TopDestinationsSection({
    super.key,
    required this.temples,
    required this.onTap,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (temples.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Top Destinations  View All
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Top Destinations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                      letterSpacing: -0.2,
                    ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onViewAll();
                },
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFFE65100),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal List View
        SizedBox(
          height: 136,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: temples.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final temple = temples[index];
              final locationName = temple.location is Location
                  ? (temple.location as Location).name
                  : (temple.location is Map ? temple.location['name'] ?? '' : 'Vrindavan');

              return Container(
                width: 130,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF27272A) : const Color(0xFFEFEFEF),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? const Color(0x20000000) : const Color(0x0A000000),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(temple),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Image
                        CachedNetworkImage(
                          imageUrl: temple.thumbnailImage?.isNotEmpty == true
                              ? temple.thumbnailImage!
                              : (temple.coverImage.isNotEmpty ? temple.coverImage : 'https://via.placeholder.com/300'),
                          height: 86,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 86,
                            color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 86,
                            color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                            child: const Icon(Icons.temple_hindu_outlined, size: 28, color: Color(0xFF71717A)),
                          ),
                        ),

                        // Bottom Metadata (Title + Location - Snug Fit)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                temple.name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      height: 1.15,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 12,
                                    color: Color(0xFFE65100),
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      locationName.isNotEmpty ? locationName : 'Vrindavan',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
