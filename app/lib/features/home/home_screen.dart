import 'dart:async';
// ignore_for_file: avoid_unused_result, unused_result
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/temple_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/ad_banner_widget.dart';
import '../../core/localization/app_translations.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/aarti_countdown_card.dart';
import 'widgets/weather_yatra_card.dart';
import 'widgets/festival_banner.dart';
import 'widgets/emergency_quick_action.dart';
import 'widgets/daily_krishna_vani.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategoryId;

  Future<void> _openNearbyHotels() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/hotels+near+vrindavan');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('all')) return Icons.grid_view_outlined;
    if (name.contains('shrine') || name.contains('temple') || name.contains('mandir')) return Icons.temple_hindu_outlined;
    if (name.contains('dham') || name.contains('ghat') || name.contains('place')) return Icons.location_on_outlined;
    if (name.contains('heritage') || name.contains('history')) return Icons.history_edu_outlined;
    if (name.contains('utsav') || name.contains('festival')) return Icons.celebration_outlined;
    return Icons.category_outlined;
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron;
    final inactiveColor = theme.colorScheme.onSurface;
    final activeBg = isDark
        ? AppTheme.primarySaffronDark.withValues(alpha: 0.15)
        : AppTheme.primarySaffron.withValues(alpha: 0.1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        minVerticalPadding: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Icon(
          icon,
          size: 22,
          color: isSelected ? activeColor : inactiveColor.withValues(alpha: 0.85),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? activeColor : inactiveColor,
            fontSize: 14.5,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? activeColor.withValues(alpha: 0.8) : inactiveColor.withValues(alpha: 0.6),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLang = ref.watch(appLanguageProvider);
    final featuredAsync = ref.watch(featuredTemplesProvider);
    final popularAsync = ref.watch(popularTemplesProvider);
    final allTemplesAsync = ref.watch(allTemplesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final festivalsAsync = ref.watch(festivalsProvider);

    debugPrint('🏗 [HomeScreen] Provider states - featured: ${featuredAsync.runtimeType}, popular: ${popularAsync.runtimeType}, all: ${allTemplesAsync.runtimeType}, categories: ${categoriesAsync.runtimeType}, festivals: ${festivalsAsync.runtimeType}');

    return SafeArea(
      top: true,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Drawer Header Container (Saffron/Cream Theme)
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
                        color: AppTheme.templeGold.withValues(alpha: 0.4),
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
                          color: AppTheme.templeGold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.temple_hindu_outlined,
                          size: 32,
                          color: AppTheme.templeGold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Braj Darshan',
                        style: GoogleFonts.rozhaOne(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Theme.of(context).colorScheme.onSurface,
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
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.home_outlined,
                        title: AppTranslations.getText(currentLang, 'home'),
                        isSelected: true,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.search_outlined,
                        title: AppTranslations.getText(currentLang, 'search_shrines'),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          context.push('/search');
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.favorite_border,
                        title: AppTranslations.getText(currentLang, 'saved_favorites'),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          context.push('/favorites');
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.celebration_outlined,
                        title: AppTranslations.getText(currentLang, 'festivals'),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          context.push('/festivals');
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.map_outlined,
                        title: AppTranslations.getText(currentLang, 'interactive_map'),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          context.push('/map');
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.night_shelter_outlined,
                        title: AppTranslations.getText(currentLang, 'nearby_hotels'),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          _openNearbyHotels();
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.event_note_outlined,
                        title: 'My Yatra Planner',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          context.push('/yatra-planner');
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Divider(height: 1, thickness: 0.5),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: ExpansionTile(
                          shape: const Border(),
                          collapsedShape: const Border(),
                          leading: const Icon(Icons.language_outlined, size: 22),
                          title: Text(
                            AppTranslations.getText(currentLang, 'language'),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          subtitle: Text(
                            currentLang == 'hi' ? 'हिंदी (Hindi)' : 'English',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                                    fillColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                                  ),
                                  RadioListTile<String>(
                                    contentPadding: const EdgeInsets.only(left: 32, right: 16),
                                    title: Text('हिंदी (Hindi)', style: Theme.of(context).textTheme.labelLarge),
                                    value: 'hi',
                                    fillColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.info_outline,
                        title: AppTranslations.getText(currentLang, 'about_app'),
                        subtitle: 'v2.0 • Braj Darshan',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          context.push('/about');
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
            style: GoogleFonts.rozhaOne(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: Theme.of(context).colorScheme.onSurface,
            ),
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
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            ref.refresh(featuredTemplesProvider);
            ref.refresh(popularTemplesProvider);
            ref.refresh(allTemplesProvider);
            ref.refresh(categoriesProvider);
            ref.refresh(festivalsProvider);
            ref.refresh(weatherProvider);
            ref.refresh(emergencyContactsProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
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

                    const SizedBox(height: 16),

                    // 2. Aarti Countdown (only when valid data exists)
                    const AartiCountdownCard(),

                    const SizedBox(height: 12),

                    // 3. Weather & Yatra Alert
                    const WeatherYatraCard(),

                    const SizedBox(height: 12),

                    // 4. Festival Banner (only during active festival)
                    const FestivalBanner(),

                    const SizedBox(height: 16),

                    // 6. Top Destinations Section (Horizontal Cards)
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

                    // 7. Nearby Temples
                    _buildNearbyTemplesSection(context, currentLang, allTemplesAsync),

                    const SizedBox(height: 24),

                    // 8. Upcoming Festivals
                    _buildUpcomingFestivalsSection(context, currentLang, festivalsAsync),

                    const SizedBox(height: 24),

                    // 10. Daily Krishna Vani
                    const DailyKrishnaVani(),

                    const SizedBox(height: 24),

                    // 11. Section Header for All Temples
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppTranslations.getText(currentLang, 'all_temples'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 12. Temple List View (Lazy Rendered)
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
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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

                    const SizedBox(height: 16),

                    // AdMob Banner (existing)
                    const AdBannerWidget(),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyTemplesSection(BuildContext context, String currentLang, AsyncValue<List<Temple>> allTemplesAsync) {
    return allTemplesAsync.when(
      data: (temples) {
        final nearbyTemples = temples.where((t) => t.isPopular).take(6).toList();
        if (nearbyTemples.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.near_me_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nearby Temples',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 19,
                              letterSpacing: -0.2,
                            ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.push('/map');
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        'View Map',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
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
            SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: nearbyTemples.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final temple = nearbyTemples[index];
                  final locationName = temple.location is Location
                      ? (temple.location as Location).name
                      : (temple.location is Map ? temple.location['name'] ?? '' : 'Vrindavan');
                  
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  
                  return Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : AppTheme.creamWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? const Color(0x20000000) : const Color(0x0A000000),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/temple/${temple.id}');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (() {
                              String imgUrl = '';
                              if (temple.coverImage.trim().isNotEmpty) {
                                imgUrl = temple.coverImage.trim();
                              } else if (temple.thumbnailImage != null && temple.thumbnailImage!.trim().isNotEmpty) {
                                imgUrl = temple.thumbnailImage!.trim();
                              } else if (temple.featuredImage != null && temple.featuredImage!.trim().isNotEmpty) {
                                imgUrl = temple.featuredImage!.trim();
                              } else if (temple.galleryImages.isNotEmpty) {
                                final g = temple.galleryImages.firstWhere(
                                  (img) => img.imageUrl.trim().isNotEmpty,
                                  orElse: () => temple.galleryImages.first,
                                );
                                if (g.imageUrl.trim().isNotEmpty) {
                                  imgUrl = g.imageUrl.trim();
                                }
                              }

                              if (imgUrl.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: imgUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 100,
                                    color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    height: 100,
                                    color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                                    child: const Icon(Icons.temple_hindu_outlined, size: 32, color: Color(0xFF71717A)),
                                  ),
                                );
                              } else {
                                return Container(
                                  height: 100,
                                  width: double.infinity,
                                  color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                                  child: const Icon(Icons.temple_hindu_outlined, size: 32, color: Color(0xFF71717A)),
                                );
                              }
                            })(),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
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
                                      Icon(
                                        Icons.location_on,
                                        size: 12,
                                        color: AppTheme.templeGold,
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          locationName.isNotEmpty ? locationName : 'Vrindavan',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
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
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildUpcomingFestivalsSection(BuildContext context, String currentLang, AsyncValue<List<Festival>> festivalsAsync) {
    return festivalsAsync.when(
      data: (festivals) {
        final now = DateTime.now();
        final upcoming = festivals
            .where((f) => f.status == 'active' && f.startDate != null && f.endDate != null)
            .where((f) {
              try {
                final end = DateTime.parse(f.endDate!);
                return end.isAfter(now.subtract(const Duration(days: 1)));
              } catch (_) { return false; }
            })
            .take(3).toList();
        if (upcoming.isEmpty) return const SizedBox.shrink();
        upcoming.sort((a, b) {
          try {
            final aStart = DateTime.parse(a.startDate!);
            final bStart = DateTime.parse(b.startDate!);
            return aStart.compareTo(bStart);
          } catch (_) { return 0; }
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.celebration_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Upcoming Festivals', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 19, letterSpacing: -0.2)),
                    ],
                  ),
                  InkWell(
                    onTap: () { HapticFeedback.lightImpact(); context.push('/festivals'); },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), child: Text('View All', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 14))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcoming.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final fest = upcoming[index];
                final isDark = Theme.of(context).brightness == Brightness.dark;
                Color festivalAccent = AppTheme.primarySaffron;
                if (fest.themeConfig?.accentColor != null && fest.themeConfig!.accentColor!.isNotEmpty) {
                  try { festivalAccent = Color(int.parse(fest.themeConfig!.accentColor!.replaceFirst('#', '0xFF'))); } catch (_) {}
                }
                final startDate = fest.startDate != null ? DateTime.parse(fest.startDate!) : null;
                final endDate = fest.endDate != null ? DateTime.parse(fest.endDate!) : null;
                final monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
                final monthBadge = startDate != null ? monthNames[startDate.month - 1] : 'UTSAV';
                return Container(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: festivalAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: festivalAccent.withValues(alpha: 0.3))), child: Column(children: [const Icon(Icons.celebration_outlined, size: 18, color: AppTheme.templeGold), const SizedBox(height: 4), Text(monthBadge, style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w800, color: festivalAccent))])),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(fest.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), if (startDate != null && endDate != null) Text(_formatFestivalDateRange(startDate, endDate), style: Theme.of(context).textTheme.bodySmall!.copyWith(color: festivalAccent, fontWeight: FontWeight.w600)), if (fest.description != null && fest.description!.isNotEmpty) ...[const SizedBox(height: 4), Text(fest.description!, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis)]])),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _formatFestivalDateRange(DateTime start, DateTime end) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (start.month == end.month && start.year == end.year) {
      return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}, ${end.year}';
    }
    return '${months[start.month - 1]} ${start.day} - ${end.day}, ${start.year}';
  }


}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: 'Category: ${category.name}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppTheme.primarySaffronDark.withValues(alpha: 0.15),
                        AppTheme.secondarySaffronDark.withValues(alpha: 0.08),
                      ]
                    : [
                        AppTheme.primarySaffron.withValues(alpha: 0.1),
                        AppTheme.secondarySaffron.withValues(alpha: 0.05),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? AppTheme.primarySaffronDark.withValues(alpha: 0.3)
                    : AppTheme.primarySaffron.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.primarySaffronDark.withValues(alpha: 0.2)
                        : AppTheme.primarySaffron.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isDark
                        ? AppTheme.primarySaffronDark
                        : AppTheme.primarySaffron,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.2,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
  const FeaturedTemplesCarousel({super.key, required this.temples, required this.onTap});
  @override State<FeaturedTemplesCarousel> createState() => _FeaturedTemplesCarouselState();
}

class _FeaturedTemplesCarouselState extends State<FeaturedTemplesCarousel> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.92);
    if (widget.temples.isNotEmpty) _startAutoScroll();
  }

  @override
  void didUpdateWidget(covariant FeaturedTemplesCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.temples.isNotEmpty &&
        (_autoScrollTimer == null || !_autoScrollTimer!.isActive)) {
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
                        imageUrl: (temple.featuredImage != null &&
                                temple.featuredImage!.isNotEmpty)
                            ? temple.featuredImage!
                            : (temple.coverImage.isNotEmpty
                                ? temple.coverImage
                                : 'https://via.placeholder.com/600'),
                        height: 195,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Theme.of(context).colorScheme.surface),
                        errorWidget: (_, __, ___) => Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: Icon(
                            Icons.temple_hindu_outlined,
                            size: 40,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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
  const TopDestinationsSection({super.key, required this.temples, required this.onTap, required this.onViewAll});
  @override
  Widget build(BuildContext context) {
    if (temples.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  : (temple.location is Map
                      ? temple.location['name'] ?? ''
                      : 'Vrindavan');
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
                      color: isDark
                          ? const Color(0x20000000)
                          : const Color(0x0A000000),
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
                        (() {
                          String imgUrl = '';
                          if (temple.coverImage.trim().isNotEmpty) {
                            imgUrl = temple.coverImage.trim();
                          } else if (temple.thumbnailImage != null &&
                              temple.thumbnailImage!.trim().isNotEmpty) {
                            imgUrl = temple.thumbnailImage!.trim();
                          } else if (temple.featuredImage != null &&
                              temple.featuredImage!.trim().isNotEmpty) {
                            imgUrl = temple.featuredImage!.trim();
                          } else if (temple.galleryImages.isNotEmpty) {
                            final g = temple.galleryImages.firstWhere(
                              (img) => img.imageUrl.trim().isNotEmpty,
                              orElse: () => temple.galleryImages.first,
                            );
                            if (g.imageUrl.trim().isNotEmpty) {
                              imgUrl = g.imageUrl.trim();
                            }
                          }

                          if (imgUrl.isNotEmpty) {
                            return CachedNetworkImage(
                              imageUrl: imgUrl,
                              height: 86,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 86,
                                color: isDark
                                    ? const Color(0xFF27272A)
                                    : const Color(0xFFF4F4F5),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 86,
                                color: isDark
                                    ? const Color(0xFF27272A)
                                    : const Color(0xFFE4E4E7),
                                child: const Icon(
                                  Icons.temple_hindu_outlined,
                                  size: 28,
                                  color: Color(0xFF71717A),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 86,
                              width: double.infinity,
                              color: isDark
                                  ? const Color(0xFF27272A)
                                  : const Color(0xFFE4E4E7),
                              child: const Icon(
                                Icons.temple_hindu_outlined,
                                size: 28,
                                color: Color(0xFF71717A),
                              ),
                            );
                          }
                        })(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 5.0),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                temple.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
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
                                    Icons.location_on,
                                    size: 13,
                                    color: Color(0xFFEA4335),
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      locationName.isNotEmpty
                                          ? locationName
                                          : 'Vrindavan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: isDark
                                                ? const Color(0xFFA1A1AA)
                                                : const Color(0xFF71717A),
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
