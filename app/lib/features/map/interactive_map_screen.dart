import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../core/config/constants.dart';

class InteractiveMapScreen extends ConsumerStatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  ConsumerState<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends ConsumerState<InteractiveMapScreen> {
  final MapController _mapController = MapController();
  Temple? _selectedTemple;
  static const LatLng _vrindavanCenter = LatLng(AppConstants.defaultLat, AppConstants.defaultLng);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMarkerTapped(Temple temple) {
    HapticFeedback.lightImpact();
    setState(() => _selectedTemple = temple);
    _mapController.move(LatLng(temple.latitude, temple.longitude), 15.0);
  }

  void _resetToCenter() {
    HapticFeedback.lightImpact();
    setState(() => _selectedTemple = null);
    _mapController.move(_vrindavanCenter, 13.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTemplesAsync = ref.watch(allTemplesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interactive Dham Map',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            tooltip: 'Reset Camera',
            icon: const Icon(Icons.my_location_outlined),
            onPressed: _resetToCenter,
          ),
        ],
      ),
      body: allTemplesAsync.when(
        data: (temples) {
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _vrindavanCenter,
                  initialZoom: 13.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                  onTap: (_, __) {
                    if (_selectedTemple != null) {
                      setState(() => _selectedTemple = null);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                    userAgentPackageName: 'com.brajdarshan.app',
                    tileBuilder: isDark
                        ? (context, tileWidget, tile) {
                            return ColorFiltered(
                              colorFilter: const ColorFilter.matrix([
                                -0.2126, -0.7152, -0.0722, 0, 255,
                                -0.2126, -0.7152, -0.0722, 0, 255,
                                -0.2126, -0.7152, -0.0722, 0, 255,
                                0,       0,       0,       1, 0,
                              ]),
                              child: tileWidget,
                            );
                          }
                        : null,
                  ),

                  MarkerLayer(
                    markers: temples.map((temple) {
                      final isSelected = _selectedTemple?.id == temple.id;
                      return Marker(
                        point: LatLng(temple.latitude, temple.longitude),
                        width: isSelected ? 48.0 : 44.0,
                        height: isSelected ? 48.0 : 44.0,
                        child: Semantics(
                          label: 'Map Marker for ${temple.name}',
                          button: true,
                          child: GestureDetector(
                            onTap: () => _onMarkerTapped(temple),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.outline,
                                  width: isSelected ? 2.5 : 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.temple_hindu,
                                size: isSelected ? 22 : 18,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'map_zoom_in',
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, (currentZoom + 1).clamp(5.0, 18.0));
                      },
                      child: const Icon(Icons.add, size: 20),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'map_zoom_out',
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, (currentZoom - 1).clamp(5.0, 18.0));
                      },
                      child: const Icon(Icons.remove, size: 20),
                    ),
                  ],
                ),
              ),

              if (_selectedTemple != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow.withOpacity( 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Semantics(
                                label: _selectedTemple!.name,
                                image: true,
                                child: CachedNetworkImage(
                                  imageUrl: _selectedTemple!.coverImage.isNotEmpty
                                      ? _selectedTemple!.coverImage
                                      : 'https://via.placeholder.com/150',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Theme.of(context).colorScheme.surface,
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Theme.of(context).colorScheme.surface,
                                    child: Icon(Icons.temple_hindu_outlined, size: 28, color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedTemple!.name,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 13,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          _selectedTemple!.location is Location
                                              ? (_selectedTemple!.location as Location).name
                                              : 'Vrindavan Dham',
                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
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
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => setState(() => _selectedTemple = null),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: Text(
                            'View Temple Details',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            context.push('/temple/${_selectedTemple!.id}');
                          },
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 0.3, duration: 250.ms).fadeIn(),
                ),
            ],
          );
        },
        loading: () => const LoadingSkeleton(height: 400),
        error: (err, _) => ErrorView(
          message: 'Failed to load map shrines',
          onRetry: () => ref.refresh(allTemplesProvider),
        ),
      ),
    );
  }
}

