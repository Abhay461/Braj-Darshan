import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class TempleCard extends ConsumerStatefulWidget {
  final Temple temple;
  final VoidCallback onTap;
  final double imageHeight;
  final String? heroTag;
  final bool showImage;
  final bool showDetails;

  const TempleCard({
    super.key,
    required this.temple,
    required this.onTap,
    this.imageHeight = 110.0,
    this.heroTag,
    this.showImage = true,
    this.showDetails = true,
  });

  @override
  ConsumerState<TempleCard> createState() => _TempleCardState();
}

class _TempleCardState extends ConsumerState<TempleCard> with SingleTickerProviderStateMixin {
  late AnimationController _favoriteAnimController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _favoriteAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _favoriteAnimController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _favoriteAnimController.dispose();
    super.dispose();
  }

  void _onFavoriteToggle() {
    HapticFeedback.lightImpact();
    _favoriteAnimController.forward().then((_) => _favoriteAnimController.reverse());
    ref.read(favoritesProvider.notifier).toggleFavorite(widget.temple.id);
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(widget.temple.id);

    final locationName = widget.temple.location is Location
        ? (widget.temple.location as Location).name
        : (widget.temple.location is Map ? widget.temple.location['name'] ?? '' : 'Vrindavan');

    // -------------------------------------------------------------------------
    // 1. Clean Soft Card List Item
    // -------------------------------------------------------------------------
    if (!widget.showImage) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141417) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF27272A) : const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? const Color(0x20000000) : const Color(0x06000000),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.temple_hindu_outlined,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF18181B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.temple.name,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF71717A)),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                locationName.isNotEmpty ? locationName : 'Vrindavan',
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                  // Favorite Heart Button
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: IconButton(
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFav ? const Color(0xFFDC2626) : const Color(0xFF71717A),
                      ),
                      onPressed: _onFavoriteToggle,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 18, color: Color(0xFFA1A1AA)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final tag = widget.heroTag ?? 'temple_image_${widget.temple.id}';

    // -------------------------------------------------------------------------
    // 2. Image-Only Mode (for Top Featured Carousel)
    // -------------------------------------------------------------------------
    if (!widget.showDetails) {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141417) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? const Color(0x20000000) : const Color(0x08000000),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Hero(
                  tag: tag,
                  child: CachedNetworkImage(
                    imageUrl: widget.temple.thumbnailImage?.isNotEmpty == true
                        ? widget.temple.thumbnailImage!
                        : (widget.temple.coverImage.isNotEmpty ? widget.temple.coverImage : 'https://via.placeholder.com/300'),
                    height: widget.imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: widget.imageHeight,
                      color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: widget.imageHeight,
                      color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                      child: const Icon(Icons.temple_hindu_outlined, size: 36, color: Color(0xFF71717A)),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? const Color(0xFFDC2626) : (isDark ? Colors.white : const Color(0xFF18181B)),
                        ),
                        onPressed: _onFavoriteToggle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // 3. Standard Card Mode (Image + Details)
    // -------------------------------------------------------------------------
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141417) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x20000000) : const Color(0x08000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image & Favorite Badge Stack
              Stack(
                children: [
                  Hero(
                    tag: tag,
                    child: Semantics(
                      label: widget.temple.name,
                      image: true,
                      child: CachedNetworkImage(
                        imageUrl: widget.temple.thumbnailImage?.isNotEmpty == true
                            ? widget.temple.thumbnailImage!
                            : (widget.temple.coverImage.isNotEmpty ? widget.temple.coverImage : 'https://via.placeholder.com/300'),
                        height: widget.imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: widget.imageHeight,
                          color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: widget.imageHeight,
                          color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                          child: const Icon(Icons.temple_hindu_outlined, size: 36, color: Color(0xFF71717A)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? const Color(0xFFDC2626) : (isDark ? Colors.white : const Color(0xFF18181B)),
                          ),
                          onPressed: _onFavoriteToggle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Name & Location Metadata
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.temple.nameHindi?.isNotEmpty == true
                          ? '${widget.temple.name} (${widget.temple.nameHindi})'
                          : widget.temple.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF71717A)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            locationName.isNotEmpty ? locationName : 'Vrindavan',
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
  }
}
