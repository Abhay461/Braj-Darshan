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
import '../../shared/widgets/ad_banner_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_translations.dart';

class TempleDetailScreen extends ConsumerStatefulWidget {
  final String templeId;
  const TempleDetailScreen({super.key, required this.templeId});

  @override
  ConsumerState<TempleDetailScreen> createState() => _TempleDetailScreenState();
}

class _TempleDetailScreenState extends ConsumerState<TempleDetailScreen> {
  Temple? _temple;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _loadTemple();
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

  Future<void> _loadTemple() async {
    final repo = ref.read(templeRepositoryProvider);
    final data = await repo.getTempleByIdOrSlug(widget.templeId);
    if (mounted) {
      setState(() {
        _temple = data;
        _isLoading = false;
      });
    }
  }

  void _openGoogleMaps(double lat, double lng, String name) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _shareTemple(Temple temple) {
    HapticFeedback.lightImpact();
    Share.share('Explore ${temple.name} on Braj Darshan! Location: ${temple.address?.full ?? "Vrindavan"}');
  }

  void _openPlanYatraBottomSheet(Temple temple) {
    HapticFeedback.lightImpact();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    bool oneDayBefore = true;
    String reminderOption = '30_mins';
    TextEditingController notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final dateStr = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
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
                      leading: const Icon(Icons.calendar_month, color: AppTheme.saffronHighlight),
                      title: Text('Planned Visit Date', style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text(dateStr, style: Theme.of(context).textTheme.titleMedium),
                      trailing: TextButton(
                        child: Text(
                          'Change Date',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppTheme.saffronHighlight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                      ),
                    ),

                    const Divider(),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('1 Day Before Evening Reminder', style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text('Get an alert at 8:00 PM the evening before your visit', style: Theme.of(context).textTheme.bodySmall),
                      value: oneDayBefore,
                      activeColor: AppTheme.saffronHighlight,
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        setModalState(() => oneDayBefore = val);
                      },
                    ),

                    const Divider(),

                    Text('Pre-Darshan Reminder Option', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('30 Mins Before'),
                          selected: reminderOption == '30_mins',
                          onSelected: (val) {
                            HapticFeedback.selectionClick();
                            setModalState(() => reminderOption = '30_mins');
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('1 Hour Before'),
                          selected: reminderOption == '1_hour',
                          onSelected: (val) {
                            HapticFeedback.selectionClick();
                            setModalState(() => reminderOption = '1_hour');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: notesController,
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
                          plannedDate: selectedDate,
                          openingTime: temple.darshanTiming?.isNotEmpty == true ? '07:45 AM' : '',
                          closingTime: temple.darshanTiming?.isNotEmpty == true ? '12:00 PM' : '',
                          notes: notesController.text,
                          reminderOption: reminderOption,
                          oneDayBeforeReminder: oneDayBefore,
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
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
      );
    }

    if (_temple == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Temple Details')),
        body: const Center(child: Text('Temple not found')),
      );
    }

    final temple = _temple!;
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(temple.id);
    final currentLang = ref.watch(appLanguageProvider);

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
            IconButton(
              icon: Icon(Icons.share_outlined, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => _shareTemple(temple),
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
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  locationName,
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                          icon: const Icon(Icons.event_available_outlined, size: 18),
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
                            _openGoogleMaps(temple.latitude, temple.longitude, temple.name);
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

