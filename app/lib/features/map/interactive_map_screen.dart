import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    _mapController.move(_getEffectiveLatLng(temple), 15.0);
  }

  void _resetToCenter() {
    HapticFeedback.lightImpact();
    setState(() => _selectedTemple = null);
    _mapController.move(_vrindavanCenter, 13.0);
  }

  /// Get effective location for a temple: try directionsUrl extraction first,
  /// then fall back to temple's own lat/lng, then location's lat/lng.
  LatLng _getEffectiveLatLng(Temple temple) {
    // 1. Try extracting from directionsUrl if available
    if (temple.directionsUrl != null && temple.directionsUrl!.trim().isNotEmpty) {
      final parsed = _extractLatLngFromUrl(temple.directionsUrl!.trim());
      if (parsed != null) return parsed;
    }
    // 2. Use temple's stored database coordinates if valid and not hardcoded default
    final isDefault = (temple.latitude == 27.5830 && temple.longitude == 77.7000);
    if (!isDefault && temple.latitude != 0.0 && temple.longitude != 0.0) {
      return LatLng(temple.latitude, temple.longitude);
    }
    // 3. Use location model coordinates if available
    if (temple.location is Location) {
      final loc = temple.location as Location;
      if (loc.latitude != 0.0 && loc.longitude != 0.0 &&
          !(loc.latitude == 27.5830 && loc.longitude == 77.7000)) {
        return LatLng(loc.latitude, loc.longitude);
      }
    }
    // 4. Fallback to temple's stored coordinates
    return LatLng(temple.latitude, temple.longitude);
  }

  bool _hasValidLocation(Temple temple) {
    final effective = _getEffectiveLatLng(temple);
    // Filter out temples that are still at the hardcoded default
    return !(effective.latitude == 27.5830 && effective.longitude == 77.7000);
  }

  LatLng? _extractLatLngFromUrl(String text) {
    if (text.isEmpty) return null;
    try {
      var decoded = text.replaceAll('%2C', ',').replaceAll('%2c', ',');
      try { decoded = Uri.decodeFull(decoded); } catch (_) {}

      // 1. !3d=lat !4d=lng
      final d3d4d = RegExp(r'!3d(-?\d+\.\d+)!4d(-?\d+\.\d+)').firstMatch(decoded);
      if (d3d4d != null) {
        final lat = double.tryParse(d3d4d.group(1)!);
        final lng = double.tryParse(d3d4d.group(2)!);
        if (lat != null && lng != null && _isValidLatLng(lat, lng)) return LatLng(lat, lng);
      }
      // 2. !2d=lng !3d=lat
      final d2d3d = RegExp(r'!2d(-?\d+\.\d+)!3d(-?\d+\.\d+)').firstMatch(decoded);
      if (d2d3d != null) {
        final lng = double.tryParse(d2d3d.group(1)!);
        final lat = double.tryParse(d2d3d.group(2)!);
        if (lat != null && lng != null && _isValidLatLng(lat, lng)) return LatLng(lat, lng);
      }
      // 3. @lat,lng
      final atMatch = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)').firstMatch(decoded);
      if (atMatch != null) {
        final lat = double.tryParse(atMatch.group(1)!);
        final lng = double.tryParse(atMatch.group(2)!);
        if (lat != null && lng != null && _isValidLatLng(lat, lng)) return LatLng(lat, lng);
      }
      // 4. query/q/ll/center/destination param
      final paramMatch = RegExp(r'(?:query|q|ll|center|destination|loc:)=(-?\d+\.\d+)[,\+ ]+(-?\d+\.\d+)').firstMatch(decoded);
      if (paramMatch != null) {
        final lat = double.tryParse(paramMatch.group(1)!);
        final lng = double.tryParse(paramMatch.group(2)!);
        if (lat != null && lng != null && _isValidLatLng(lat, lng)) return LatLng(lat, lng);
      }
      // 5. /lat,lng in path
      final dirMatch = RegExp(r'/(-?\d{1,2}\.\d+),(-?\d{1,3}\.\d+)').firstMatch(decoded);
      if (dirMatch != null) {
        final lat = double.tryParse(dirMatch.group(1)!);
        final lng = double.tryParse(dirMatch.group(2)!);
        if (lat != null && lng != null && _isValidLatLng(lat, lng)) return LatLng(lat, lng);
      }
      // 6. India-range coordinate pair
      final indiaMatches = RegExp(r'(2[0-9]\.\d{3,})[,\s]+(7[0-9]\.\d{3,})').allMatches(decoded);
      for (final m in indiaMatches) {
        final lat = double.tryParse(m.group(1)!);
        final lng = double.tryParse(m.group(2)!);
        if (lat != null && lng != null && _isValidLatLng(lat, lng)) return LatLng(lat, lng);
      }
      // 7. General 4+ decimal pair
      final pairMatches = RegExp(r'(-?\d{1,2}\.\d{4,})[,\s]+(-?\d{1,3}\.\d{4,})').allMatches(decoded);
      for (final m in pairMatches) {
        final lat = double.tryParse(m.group(1)!);
        final lng = double.tryParse(m.group(2)!);
        if (lat != null && lng != null && _isValidLatLng(lat, lng)) return LatLng(lat, lng);
      }
    } catch (_) {}
    return null;
  }

  bool _isValidLatLng(double lat, double lng) {
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return false;
    if (lat == 0.0 && lng == 0.0) return false;
    return true;
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
              // DEBUG: Coordinate display for selected temple (only in debug mode)
              if (kDebugMode && _selectedTemple != null)
                Positioned(
                  top: 80,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedTemple!.name,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lat: ${_getEffectiveLatLng(_selectedTemple!).latitude.toStringAsFixed(6)}, Lng: ${_getEffectiveLatLng(_selectedTemple!).longitude.toStringAsFixed(6)}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace'),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Camera: ${_mapController.camera.center.latitude.toStringAsFixed(6)}, ${_mapController.camera.center.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(color: Colors.yellow, fontSize: 10, fontFamily: 'monospace'),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
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
                    markers: temples.where(_hasValidLocation).map((temple) {
                      final isSelected = _selectedTemple?.id == temple.id;
                      final effectivePos = _getEffectiveLatLng(temple);
                      return Marker(
                        point: effectivePos,
                        width: 220.0,
                        height: 90.0,
                        alignment: Alignment.bottomCenter,
                        child: Semantics(
                          label: 'Map Marker for ${temple.name}',
                          button: true,
                          child: GestureDetector(
                            onTap: () => _onMarkerTapped(temple),
                            child: AnimatedScale(
                              alignment: Alignment.bottomCenter,
                              scale: isSelected ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    temple.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color(0xFFB91C1C)
                                          : const Color(0xFFC5221F),
                                      fontSize: isSelected ? 13.5 : 12.0,
                                      fontWeight: FontWeight.w900,
                                      height: 1.15,
                                      letterSpacing: -0.3,
                                      shadows: const [
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(1.5, 1.5)),
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(-1.5, -1.5)),
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(1.5, -1.5)),
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(-1.5, 1.5)),
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, 1.5)),
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, -1.5)),
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(1.5, 0)),
                                        Shadow(color: Colors.white, blurRadius: 4, offset: Offset(-1.5, 0)),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
const SizedBox(height: 2),
                                  // Transform to align pin visual tip with map coordinate (bottomCenter)
                                  // Material Icons.location_on tip is ~2-3px above widget bottom edge
                                  Transform.translate(
                                    offset: const Offset(0, 3),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: isSelected ? 42 : 36,
                                          color: isSelected
                                              ? const Color(0xFFB91C1C)
                                              : const Color(0xFFC5221F),
                                          shadows: const [
                                            Shadow(
                                              color: Color(0x40000000),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: 8,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                  bottom: 12,
                  left: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
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
                              borderRadius: BorderRadius.circular(10),
                              child: Semantics(
                                label: _selectedTemple!.name,
                                image: true,
                                child: CachedNetworkImage(
                                  imageUrl: _selectedTemple!.coverImage.isNotEmpty
                                      ? _selectedTemple!.coverImage
                                      : 'https://via.placeholder.com/150',
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 52,
                                    height: 52,
                                    color: Theme.of(context).colorScheme.surface,
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    width: 52,
                                    height: 52,
                                    color: Theme.of(context).colorScheme.surface,
                                    child: Icon(Icons.temple_hindu_outlined, size: 24, color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedTemple!.name,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 13,
                                        color: const Color(0xFFEA4335),
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          _selectedTemple!.location is Location
                                              ? (_selectedTemple!.location as Location).name
                                              : 'Vrindavan Dham',
                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
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
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => setState(() => _selectedTemple = null),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 15),
                          label: Text(
                            'View Temple Details',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
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

