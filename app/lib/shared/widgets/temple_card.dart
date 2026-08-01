import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class TempleCard extends ConsumerWidget {
  final Temple temple;
  final VoidCallback onTap;

  const TempleCard({
    super.key,
    required this.temple,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(temple.id);

    final locationName = temple.location is Location
        ? (temple.location as Location).name
        : (temple.location is Map ? temple.location['name'] ?? '' : 'Vrindavan');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image with Favorite Button
            Stack(
              children: [
                Hero(
                  tag: 'temple_image_${temple.id}',
                  child: CachedNetworkImage(
                    imageUrl: temple.thumbnailImage ?? temple.coverImage,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      color: const Color(0xFFF4F4F5),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: const Color(0xFFE4E4E7),
                      child: const Icon(Icons.temple_hindu_outlined, size: 48),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    radius: 18,
                    child: IconButton(
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFDC2626) : const Color(0xFF18181B),
                      ),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(temple.id);
                      },
                    ),
                  ),
                ),
                if (temple.isFeatured)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  ),
              ],
            ),

            // Content Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    temple.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF18181B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF71717A)),
                      const SizedBox(width: 4),
                      Text(
                        locationName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF71717A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    temple.shortDescription,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF71717A),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
