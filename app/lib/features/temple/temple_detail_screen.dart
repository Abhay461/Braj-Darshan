import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/ad_banner_widget.dart';

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

    final locationName = temple.location is Location
        ? (temple.location as Location).name
        : (temple.location is Map ? temple.location['name'] ?? '' : 'Vrindavan');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
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
                // 1. Clean Bounded Banner Image Card
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
                  title: 'Darshan & Aarti Timings',
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
                    title: 'History & Details',
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
                const SizedBox(height: 90), // Padding for sticky bottom button
              ],
            ),
          ),

          // Floating Scroll To Top Button
          if (_showScrollToTop)
            Positioned(
              bottom: 90,
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

          // Sticky Bottom Get Directions Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141417) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? const Color(0x30000000) : const Color(0x0A000000),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : const Color(0xFF18181B),
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.directions_outlined, size: 18),
                  label: const Text(
                    'Get Directions',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  onPressed: () => _openGoogleMaps(temple.latitude, temple.longitude, temple.name),
                ),
              ),
            ),
          ),
        ],
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141417) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7)),
      ),
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
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF18181B),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
