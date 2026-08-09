import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/models.dart';
import '../../shared/models/yatra_plan.dart';
import '../../shared/providers/providers.dart';
import '../../shared/providers/yatra_planner_provider.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/ad_banner_widget.dart';
import '../../core/services/ad_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_translations.dart';

class TempleDetailScreen extends ConsumerStatefulWidget {
  final String templeId;
  const TempleDetailScreen({super.key, required this.templeId});

  @override
  ConsumerState<TempleDetailScreen> createState() => _TempleDetailScreenState();
}

class _TempleDetailScreenState extends ConsumerState<TempleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    AdService.incrementTempleViewAndCheckAd();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 300 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openGoogleMaps(Temple temple, double lat, double lng) async {
    final targetUrl = (temple.directionsUrl != null && temple.directionsUrl!.isNotEmpty)
        ? temple.directionsUrl!
        : 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final Uri url = Uri.parse(targetUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _shareTemple(Temple temple) {
    HapticFeedback.lightImpact();
    Share.share('Explore ${temple.name} on Braj Darshan! Location: ${temple.address?.full ?? "Vrindavan"}');
  }

  void _openDonateDialog(Temple temple) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.volunteer_activism_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Temple Seva & Donation',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support temple maintenance, annakshetra, and daily seva for ${temple.name}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Direct online seva & donation via official temple trust.',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Donate Online'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final targetUrl = (temple.donationUrl != null && temple.donationUrl!.isNotEmpty)
                  ? temple.donationUrl!
                  : 'https://www.google.com/search?q=donate+to+${Uri.encodeComponent(temple.name)}+vrindavan+official';
              final Uri url = Uri.parse(targetUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }

  void _openGuestHouseBooking(Temple temple) async {
    HapticFeedback.lightImpact();
    final targetUrl = (temple.guestHouseBookingUrl != null && temple.guestHouseBookingUrl!.isNotEmpty)
        ? temple.guestHouseBookingUrl!
        : 'https://www.google.com/maps/search/dharamshala+guest+house+near+${Uri.encodeComponent(temple.name)}';
    final Uri url = Uri.parse(targetUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _openLiveDarshan(Temple temple) async {
    HapticFeedback.lightImpact();
    if (temple.liveDarshanUrl == null || temple.liveDarshanUrl!.isEmpty) return;
    final Uri url = Uri.parse(temple.liveDarshanUrl!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _openPlanYatraBottomSheet(Temple temple) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PlanYatraBottomSheetContent(temple: temple),
    );
  }

  @override
  Widget build(BuildContext context) {
    final templeAsync = ref.watch(templeDetailProvider(widget.templeId));
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(widget.templeId);
    final currentLang = ref.watch(appLanguageProvider);

    return templeAsync.when(
      data: (temple) {
        if (temple == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Temple Details')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.temple_hindu_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Temple Not Found', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(templeDetailProvider(widget.templeId)),
                    child: const Text('Retry Loading'),
                  ),
                ],
              ),
            ),
          );
        }

        final locationName = temple.location is Location
            ? (temple.location as Location).name
            : (temple.location is Map ? temple.location['name'] ?? '' : 'Vrindavan');

        return SafeArea(
          top: true,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                temple.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(favoritesProvider.notifier).toggleFavorite(temple.id);
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  onSelected: (value) {
                    if (value == 'live_darshan') {
                      _openLiveDarshan(temple);
                    } else if (value == 'donate') {
                      _openDonateDialog(temple);
                    } else if (value == 'guest_house') {
                      _openGuestHouseBooking(temple);
                    } else if (value == 'share') {
                      _shareTemple(temple);
                    }
                  },
                  itemBuilder: (context) {
                    final hasLiveDarshan = temple.liveDarshanUrl != null && temple.liveDarshanUrl!.trim().isNotEmpty;
                    final hasDonate = temple.donationUrl != null && temple.donationUrl!.trim().isNotEmpty;
                    final hasGuestHouse = temple.guestHouseBookingUrl != null && temple.guestHouseBookingUrl!.trim().isNotEmpty;

                    return [
                      if (hasLiveDarshan)
                        const PopupMenuItem(
                          value: 'live_darshan',
                          child: Row(
                            children: [
                              Icon(Icons.live_tv_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Live Darshan'),
                            ],
                          ),
                        ),
                      if (hasDonate)
                        const PopupMenuItem(
                          value: 'donate',
                          child: Row(
                            children: [
                              Icon(Icons.volunteer_activism_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Donate'),
                            ],
                          ),
                        ),
                      if (hasGuestHouse)
                        const PopupMenuItem(
                          value: 'guest_house',
                          child: Row(
                            children: [
                              Icon(Icons.night_shelter_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Book Guest House'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share_outlined, size: 20),
                            SizedBox(width: 12),
                            Text('Share Temple'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Hero(
                          tag: 'temple_image_${temple.id}',
                          child: Semantics(
                            label: temple.name,
                            image: true,
                            child: CachedNetworkImage(
                              imageUrl: temple.coverImage.isNotEmpty ? temple.coverImage : 'https://via.placeholder.com/600',
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                height: 220,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              errorWidget: (_, __, ___) => Container(
                                height: 220,
                                color: Theme.of(context).colorScheme.surface,
                                child: Icon(Icons.temple_hindu_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  temple.name,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      locationName,
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildSectionCard(
                        context: context,
                        icon: Icons.access_time_outlined,
                        title: AppTranslations.getText(currentLang, 'darshan_timing'),
                        child: Text(
                          temple.darshanTiming?.isNotEmpty == true
                              ? temple.darshanTiming!
                              : 'Morning: 05:00 AM – 12:00 PM\nEvening: 04:00 PM – 09:00 PM',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (temple.history?.isNotEmpty == true)
                        _buildSectionCard(
                          context: context,
                          icon: Icons.auto_stories_outlined,
                          title: AppTranslations.getText(currentLang, 'history'),
                          child: Text(
                            temple.history!,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),
                      const AdBannerWidget(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                if (_showScrollToTop)
                  Positioned(
                    bottom: 100,
                    right: 16,
                    child: FloatingActionButton.small(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: const Icon(Icons.arrow_upward, size: 18),
                    ),
                  ).animate().scale(duration: 200.ms),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.saffronHighlight,
                                foregroundColor: Colors.black,
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.event_available_outlined, size: 18, color: Colors.black),
                              label: Text(
                                AppTranslations.getText(currentLang, 'plan_yatra'),
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () => _openPlanYatraBottomSheet(temple),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.directions_outlined, size: 18),
                              label: Text(
                                AppTranslations.getText(currentLang, 'directions'),
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _openGoogleMaps(temple, temple.latitude, temple.longitude);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Temple Details')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              LoadingSkeleton(height: 220, borderRadius: 18),
              SizedBox(height: 16),
              LoadingSkeleton(height: 120, borderRadius: 18),
              SizedBox(height: 16),
              LoadingSkeleton(height: 180, borderRadius: 18),
            ],
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Temple Details')),
        body: ErrorView(
          message: 'Failed to load temple details',
          onRetry: () => ref.refresh(templeDetailProvider(widget.templeId)),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _PlanYatraBottomSheetContent extends ConsumerStatefulWidget {
  final Temple temple;
  const _PlanYatraBottomSheetContent({required this.temple});

  @override
  ConsumerState<_PlanYatraBottomSheetContent> createState() => _PlanYatraBottomSheetContentState();
}

class _PlanYatraBottomSheetContentState extends ConsumerState<_PlanYatraBottomSheetContent> {
  late DateTime _selectedDate;
  late bool _oneDayBefore;
  late String _reminderOption;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _oneDayBefore = true;
    _reminderOption = '30_mins';
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    final temple = widget.temple;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Plan Yatra Visit — ${temple.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
              title: Text('Planned Visit Date', style: Theme.of(context).textTheme.titleSmall),
              subtitle: Text(dateStr, style: Theme.of(context).textTheme.titleMedium),
              trailing: TextButton(
                child: Text(
                  'Change Date',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
            ),

            const Divider(),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('1 Day Before Evening Reminder', style: Theme.of(context).textTheme.titleSmall),
              subtitle: Text('Get an alert at 8:00 PM the evening before your visit', style: Theme.of(context).textTheme.bodySmall),
              value: _oneDayBefore,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              onChanged: (val) {
                HapticFeedback.selectionClick();
                setState(() => _oneDayBefore = val);
              },
            ),

            const Divider(),

            Text('Pre-Darshan Reminder Option', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('30 Mins Before'),
                  selected: _reminderOption == '30_mins',
                  onSelected: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _reminderOption = '30_mins');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('1 Hour Before'),
                  selected: _reminderOption == '1_hour',
                  onSelected: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _reminderOption = '1_hour');
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes / Preparation (Optional)',
                hintText: 'e.g. Carry flowers, prasad, reach before 8 AM',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.saffronHighlight,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                final newPlan = YatraPlan(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  templeId: temple.id,
                  templeName: temple.name,
                  plannedDate: _selectedDate,
                  openingTime: temple.darshanTiming?.isNotEmpty == true ? '07:45 AM' : '',
                  closingTime: temple.darshanTiming?.isNotEmpty == true ? '12:00 PM' : '',
                  notes: _notesController.text,
                  reminderOption: _reminderOption,
                  oneDayBeforeReminder: _oneDayBefore,
                );

                ref.read(yatraPlannerProvider.notifier).addPlan(newPlan);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Yatra visit planned! Notification reminder scheduled.'),
                    backgroundColor: AppTheme.saffronHighlight,
                  ),
                );

                context.push('/yatra-planner');
              },
              child: Text(
                'Confirm & Save Yatra Plan',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


