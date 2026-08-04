import 'package:flutter/material.dart';
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
    setState(() => _selectedTemple = temple);
    _mapController.move(LatLng(temple.latitude, temple.longitude), 15.0);
  }

  void _resetToCenter() {
    setState(() => _selectedTemple = null);
    _mapController.move(_vrindavanCenter, 13.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTemplesAsync = ref.watch(allTemplesProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Interactive Dham Map'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
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
              // 1. flutter_map Map Canvas
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
                  // OpenStreetMap Tile Layer (with dark mode filter & zero API key requirement)
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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

                  // Temple Markers Layer
                  MarkerLayer(
                    markers: temples.map((temple) {
                      final isSelected = _selectedTemple?.id == temple.id;
                      return Marker(
                        point: LatLng(temple.latitude, temple.longitude),
                        width: isSelected ? 48.0 : 40.0,
                        height: isSelected ? 48.0 : 40.0,
                        child: GestureDetector(
                          onTap: () => _onMarkerTapped(temple),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? Colors.white : const Color(0xFF18181B))
                                  : (isDark ? const Color(0xFF141417) : Colors.white),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFDC2626)
                                    : (isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7)),
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
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark ? Colors.white : const Color(0xFF18181B)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // 2. Floating Map Controls (Zoom in / out / Recenter)
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'map_zoom_in',
                      backgroundColor: isDark ? const Color(0xFF141417) : Colors.white,
                      foregroundColor: isDark ? Colors.white : const Color(0xFF18181B),
                      onPressed: () {
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, (currentZoom + 1).clamp(5.0, 18.0));
                      },
                      child: const Icon(Icons.add, size: 20),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'map_zoom_out',
                      backgroundColor: isDark ? const Color(0xFF141417) : Colors.white,
                      foregroundColor: isDark ? Colors.white : const Color(0xFF18181B),
                      onPressed: () {
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, (currentZoom - 1).clamp(5.0, 18.0));
                      },
                      child: const Icon(Icons.remove, size: 20),
                    ),
                  ],
                ),
              ),

              // 3. Modern Bottom Sheet Preview Card for Selected Temple
              if (_selectedTemple != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF141417) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? const Color(0x40000000) : const Color(0x10000000),
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
                            // Thumbnail Preview Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
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
                                  color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF4F4F5),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                                  child: const Icon(Icons.temple_hindu_outlined, size: 28),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Name and Location details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedTemple!.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF18181B),
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF71717A)),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          _selectedTemple!.location is Location
                                              ? (_selectedTemple!.location as Location).name
                                              : 'Vrindavan Dham',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF71717A),
                                            fontWeight: FontWeight.w500,
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
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => setState(() => _selectedTemple = null),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white : const Color(0xFF18181B),
                            foregroundColor: isDark ? Colors.black : Colors.white,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text(
                            'View Temple Details',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          onPressed: () => context.push('/temple/${_selectedTemple!.id}'),
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
