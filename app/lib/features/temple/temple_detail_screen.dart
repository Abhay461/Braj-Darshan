import 'package:flutter/material.dart';
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
    Share.share('Explore ${temple.name} on Braj Darshan! Location: ${temple.address?.full ?? "Vrindavan"}');
  }

  void _openPlanYatraBottomSheet(Temple temple) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    bool oneDayBefore = true;
    String reminderOption = '30_mins';
    TextEditingController notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
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
                color: isDark ? const Color(0xFF1A1817) : Colors.white,
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
                          color: const Color(0xFFA1A1AA),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Plan Yatra Visit — ${temple.name}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF18181B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date Selection Tile
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month, color: Color(0xFFE56B00)),
                      title: const Text('Planned Visit Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(dateStr, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      trailing: TextButton(
                        child: const Text('Change Date', style: TextStyle(color: Color(0xFFE56B00), fontWeight: FontWeight.w700)),
                        onPressed: () async {
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

                    // 1 Day Before Reminder Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('1 Day Before Evening Reminder', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Get an alert at 8:00 PM the evening before your visit', style: TextStyle(fontSize: 12)),
                      value: oneDayBefore,
                      activeColor: const Color(0xFFE56B00),
                      onChanged: (val) => setModalState(() => oneDayBefore = val),
                    ),

                    const Divider(),

                    // Pre-Darshan Alert Window
                    const Text('Pre-Darshan Reminder Option', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('30 Mins Before'),
                          selected: reminderOption == '30_mins',
                          onSelected: (val) => setModalState(() => reminderOption = '30_mins'),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('1 Hour Before'),
                          selected: reminderOption == '1_hour',
                          onSelected: (val) => setModalState(() => reminderOption = '1_hour'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Notes Field
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes / Preparation (Optional)',
                        hintText: 'e.g. Carry flowers, prasad, reach before 8 AM',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Save Plan Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE56B00),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
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
                            backgroundColor: Color(0xFFE56B00),
                          ),
                        );

                        context.push('/yatra-planner');
                      },
                      child: const Text('Confirm & Save Yatra Plan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      backgroundColor: isDark ? const Color(0xFF121110) : const Color(0xFFFAF8F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1A1817) : const Color(0xFFF3EFEA),
        title: Text(
          temple.name,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF18181B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? const Color(0xFFDC2626) : (isDark ? Colors.white : const Color(0xFF18181B)),
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(temple.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: isDark ? Colors.white : const Color(0xFF18181B)),
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
                // 1. Banner Image Card
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Hero(
                    tag: 'temple_image_${temple.id}',
                    child: CachedNetworkImage(
                      imageUrl: temple.coverImage.isNotEmpty ? temple.coverImage : 'https://via.placeholder.com/600',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 220,
                        color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 220,
                        color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                        child: const Icon(Icons.temple_hindu_outlined, size: 64, color: Color(0xFF71717A)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Temple Name & Location Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            temple.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF18181B),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF71717A)),
                              const SizedBox(width: 4),
                              Text(
                                locationName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF71717A),
                                  fontWeight: FontWeight.w600,
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

                // 2. Darshan & Aarti Timings Card
                _buildSectionCard(
                  context: context,
                  icon: Icons.access_time_outlined,
                  title: AppTranslations.getText(currentLang, 'darshan_timing'),
                  child: Text(
                    temple.darshanTiming?.isNotEmpty == true
                        ? temple.darshanTiming!
                        : 'Morning: 05:00 AM – 12:00 PM\nEvening: 04:00 PM – 09:00 PM',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? const Color(0xFFD4D4D8) : const Color(0xFF3F3F46),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 3. History & Heritage Card
                if (temple.history?.isNotEmpty == true)
                  _buildSectionCard(
                    context: context,
                    icon: Icons.auto_stories_outlined,
                    title: AppTranslations.getText(currentLang, 'history'),
                    child: Text(
                      temple.history!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark ? const Color(0xFFD4D4D8) : const Color(0xFF3F3F46),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                const AdBannerWidget(),
                const SizedBox(height: 100), // Padding for dual sticky bottom bar
              ],
            ),
          ),

          // Floating Scroll To Top Button
          if (_showScrollToTop)
            Positioned(
              bottom: 100,
              right: 16,
              child: FloatingActionButton.small(
                backgroundColor: isDark ? Colors.white : const Color(0xFF18181B),
                foregroundColor: isDark ? Colors.black : Colors.white,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                  );
                },
                child: const Icon(Icons.arrow_upward, size: 18),
              ),
            ).animate().scale(duration: 200.ms),

          // Sticky Bottom Action Bar (Plan Yatra + Get Directions)
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
                    // Plan Yatra Button
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE56B00), // Saffron
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.event_available_outlined, size: 18),
                        label: Text(
                          AppTranslations.getText(currentLang, 'plan_yatra'),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        onPressed: () => _openPlanYatraBottomSheet(temple),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Get Directions Button
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : const Color(0xFF18181B),
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.directions_outlined, size: 18),
                        label: Text(
                          AppTranslations.getText(currentLang, 'directions'),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        onPressed: () => _openGoogleMaps(temple.latitude, temple.longitude, temple.name),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: isDark ? Colors.white : const Color(0xFF18181B)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF18181B),
                  letterSpacing: -0.3,
                ),
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
