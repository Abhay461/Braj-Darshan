import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/ad_banner_widget.dart';
import '../../core/services/ad_service.dart';

class TempleDetailScreen extends ConsumerStatefulWidget {
  final String templeId;

  const TempleDetailScreen({super.key, required this.templeId});

  @override
  ConsumerState<TempleDetailScreen> createState() => _TempleDetailScreenState();
}

class _TempleDetailScreenState extends ConsumerState<TempleDetailScreen> {
  Temple? _temple;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemple();
    AdService.incrementTempleViewAndCheckAd();
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              LoadingSkeleton(height: 250),
              SizedBox(height: 16),
              LoadingSkeleton(height: 100),
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
      body: CustomScrollView(
        slivers: [
          // Hero Cover Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'temple_image_${temple.id}',
                child: CachedNetworkImage(
                  imageUrl: temple.coverImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? const Color(0xFFDC2626) : Colors.black,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(temple.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  Share.share('Discover ${temple.name} in $locationName on Braj Darshan!');
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    temple.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF71717A)),
                      const SizedBox(width: 4),
                      Text(
                        locationName,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF71717A), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    temple.shortDescription,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF18181B), height: 1.5),
                  ),

                  const Divider(height: 32),

                  // Darshan Timings & Duration
                  if (temple.darshanTiming != null) ...[
                    const Text('Darshan Timings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(temple.darshanTiming!, style: const TextStyle(fontSize: 14, color: Color(0xFF71717A))),
                    const SizedBox(height: 16),
                  ],

                  // History
                  if (temple.history != null && temple.history!.isNotEmpty) ...[
                    const Text('History & Origins', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(temple.history!, style: const TextStyle(fontSize: 14, color: Color(0xFF71717A), height: 1.5)),
                    const SizedBox(height: 16),
                  ],

                  // Spiritual Importance
                  if (temple.importance != null && temple.importance!.isNotEmpty) ...[
                    const Text('Spiritual Significance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(temple.importance!, style: const TextStyle(fontSize: 14, color: Color(0xFF71717A), height: 1.5)),
                    const SizedBox(height: 16),
                  ],

                  // Gallery
                  if (temple.galleryImages.isNotEmpty) ...[
                    Text('Gallery (${temple.galleryImages.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: temple.galleryImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final img = temple.galleryImages[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: img.thumbnailUrl.isNotEmpty ? img.thumbnailUrl : img.imageUrl,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Quick Action Buttons
                  Row(
                    children: [
                      if (temple.phone != null && temple.phone!.isNotEmpty)
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.phone_outlined, size: 18),
                            label: const Text('Call Shrine'),
                            onPressed: () => launchUrl(Uri.parse('tel:${temple.phone}')),
                          ),
                        ),
                      if (temple.website != null && temple.website!.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.language_outlined, size: 18),
                            label: const Text('Website'),
                            onPressed: () => launchUrl(Uri.parse(temple.website!)),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 32),
                  const AdBannerWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
