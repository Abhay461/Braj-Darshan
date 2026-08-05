import 'dart:async';
import 'package:flutter/material.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategoryId;
  String _sortOption = 'default'; // 'default' | 'name' | 'popular'

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
    final allTemplesAsync = ref.watch(allTemplesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return SafeArea(
      top: true,
      child: Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAF9F6),
      // Left Hamburger Navigation Drawer
      drawer: Drawer(
        backgroundColor: isDark ? const Color(0xFF141417) : Colors.white,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Drawer Header Container (Soft Warm Golden Tint #C5A059)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 36, bottom: 16, left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFC5A059), // Soft Warm Golden Tint
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.temple_hindu_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppTranslations.getText(currentLang, 'app_title'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      AppTranslations.getText(currentLang, 'app_subtitle'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFFFFF8EE), fontWeight: FontWeight.w500),
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
                      leading: const Icon(Icons.location_on_outlined, size: 22),
                      title: Text(AppTranslations.getText(currentLang, 'interactive_map'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/map');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.hotel_outlined, size: 22),
                      title: Text(AppTranslations.getText(currentLang, 'nearby_hotels'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        _openNearbyHotels();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline, size: 22),
                      title: Text(AppTranslations.getText(currentLang, 'saved_favorites'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/favorites');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.event_outlined, size: 22),
                      title: Text(AppTranslations.getText(currentLang, 'festivals_utsavs'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/festivals');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.event_available_outlined, size: 22),
                      title: Text(AppTranslations.getText(currentLang, 'my_yatra_plan'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/yatra-planner');
                      },
                    ),
                    // Language Selector Expansion Tile
                    ExpansionTile(
                      shape: const Border(),
                      collapsedShape: const Border(),
                      leading: const Icon(Icons.language_outlined, size: 22),
                      title: Text(
                        AppTranslations.getText(currentLang, 'language'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: Text(
                        currentLang == 'hi' ? 'हिंदी (Hindi)' : 'English',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                      ),
                      children: [
                        RadioListTile<String>(
                          contentPadding: const EdgeInsets.only(left: 32, right: 16),
                          title: const Text('English', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          value: 'en',
                          groupValue: currentLang,
                          activeColor: const Color(0xFF18181B),
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(appLanguageProvider.notifier).setLanguage(val);
                            }
                          },
                        ),
                        RadioListTile<String>(
                          contentPadding: const EdgeInsets.only(left: 32, right: 16),
                          title: const Text('हिंदी (Hindi)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          value: 'hi',
                          groupValue: currentLang,
                          activeColor: const Color(0xFF18181B),
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(appLanguageProvider.notifier).setLanguage(val);
                            }
                          },
                        ),
                      ],
                    ),

                    // About App Tile
                    ListTile(
                      leading: const Icon(Icons.info_outline, size: 22),
                      title: Text(
                        AppTranslations.getText(currentLang, 'about_app'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: const Text('v2.0 • Braj Darshan', style: TextStyle(fontSize: 12, color: Color(0xFF71717A))),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Braj Darshan',
                          applicationVersion: '2.0.0',
                          applicationIcon: const Icon(Icons.temple_hindu, size: 36, color: Color(0xFFC5A059)),
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
        backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAF9F6),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Navigation Menu',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(Icons.menu, color: isDark ? Colors.white : const Color(0xFF18181B)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          AppTranslations.getText(currentLang, 'app_title'),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF18181B),
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: AppTranslations.getText(currentLang, 'search_shrines'),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(Icons.search_outlined, color: isDark ? Colors.white : const Color(0xFF18181B)),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),



      // Sticky Bottom Ad Banner Container
      bottomNavigationBar: SafeArea(
        child: Container(
          color: isDark ? const Color(0xFF09090B) : const Color(0xFFFAF9F6),
          child: const AdBannerWidget(),
        ),
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
          padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP SECTION: Featured Temples Auto-Scrolling Carousel with Dark Overlay & Page Dots
              featuredAsync.when(
                data: (featuredList) => FeaturedTemplesCarousel(
                  temples: featuredList,
                  onTap: (temple) => context.push('/temple/${temple.id}'),
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

              // 2. Category Chips Bar with Icons & Outline/Filled Styles
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
                          avatar: Icon(
                            _getCategoryIcon('All'),
                            size: 16,
                            color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF18181B)),
                          ),
                          label: const Text('All Temples'),
                          selectedColor: const Color(0xFF18181B),
                          backgroundColor: isDark ? const Color(0xFF141417) : Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF18181B)
                                : (isDark ? const Color(0xFF27272A) : const Color(0xFFE5E7EB)),
                            width: 1,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF18181B)),
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
                        avatar: Icon(
                          _getCategoryIcon(cat.name),
                          size: 16,
                          color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF18181B)),
                        ),
                        label: Text(cat.name),
                        selectedColor: const Color(0xFF18181B),
                        backgroundColor: isDark ? const Color(0xFF141417) : Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF18181B)
                              : (isDark ? const Color(0xFF27272A) : const Color(0xFFE5E7EB)),
                          width: 1,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF18181B)),
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

              // 3. All Temples Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  AppTranslations.getText(currentLang, 'all_temples'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF18181B),
                    letterSpacing: -0.4,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Temple List View
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

                    if (_sortOption == 'name') {
                      filteredList = [...filteredList]..sort((a, b) => a.name.compareTo(b.name));
                    }

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No temples found',
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
            ],
          ),
        ),
      ),
    ),
  );
}
}

// ---------------------------------------------------------------------------
// Featured Temples Auto-Scrolling Carousel (Dark Overlay & Page Dots)
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
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
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
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final temple = widget.temples[index % widget.temples.length];
              final locationName = temple.location is Location
                  ? (temple.location as Location).name
                  : (temple.location is Map ? temple.location['name'] ?? '' : 'Vrindavan');

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => widget.onTap(temple),
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: temple.coverImage.isNotEmpty
                          ? temple.coverImage
                          : (temple.thumbnailImage ?? 'https://via.placeholder.com/600'),
                      height: 195,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: const Color(0xFF1E1E22)),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFF27272A),
                        child: const Icon(Icons.temple_hindu_outlined, size: 40, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

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
                color: activeIndex == idx ? const Color(0xFF18181B) : const Color(0xFFD4D4D8),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
