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
import '../../shared/widgets/braj_map_pin_widget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/constants.dart';

class InteractiveMapScreen extends ConsumerStatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  ConsumerState<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends ConsumerState<InteractiveMapScreen> {
  final MapController _mapController = MapController();
  Temple? _selectedTemple;
  MapSettings? _mapSettings;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMarkerTapped(Temple temple) {
    HapticFeedback.lightImpact();
    setState(() => _selectedTemple = temple);
    final zoom = _getEffectiveZoom(temple);
    _mapController.move(_getEffectiveLatLng(temple), zoom);
  }

  void _resetToCenter() {
    HapticFeedback.lightImpact();
    setState(() => _selectedTemple = null);
    final center = _getDefaultCenter();
    final zoom = _mapSettings?.defaultZoom ?? 14.0;
    _mapController.move(center, zoom);
  }

  LatLng _getDefaultCenter() {
    if (_mapSettings != null) {
      return LatLng(_mapSettings!.defaultCenterLat, _mapSettings!.defaultCenterLng);
    }
    return LatLng(AppConstants.defaultLat, AppConstants.defaultLng);
  }

  double _getDefaultZoom() {
    return _mapSettings?.defaultZoom ?? 14.0;
  }

  double _getMinZoom() {
    return _mapSettings?.minZoom ?? 5.0;
  }

  double _getMaxZoom() {
    return _mapSettings?.maxZoom ?? 18.0;
  }

  double _getEffectiveZoom(Temple temple) {
    // Use temple-specific zoom if set, otherwise global default
    if (temple.mapZoom != null) {
      return temple.mapZoom!;
    }
    return _mapSettings?.defaultZoom ?? 15.0;
  }

  String _getEffectivePinIconStyle(Temple temple) {
    // Use temple-specific pin icon if set, otherwise global default
    if (temple.mapPinIconStyle != null && temple.mapPinIconStyle!.isNotEmpty) {
      return temple.mapPinIconStyle!;
    }
    return _mapSettings?.defaultPinIconStyle ?? 'location_on';
  }

  Color _getEffectivePinColor(Temple temple) {
    // Use temple-specific pin color if set, otherwise global default
    String colorHex;
    if (temple.mapPinColor != null && temple.mapPinColor!.isNotEmpty) {
      colorHex = temple.mapPinColor!;
    } else {
      colorHex = _mapSettings?.defaultPinColor ?? '#E65100';
    }
    return _parseColor(colorHex);
  }

  double _getEffectivePinSize(Temple temple) {
    // Use temple-specific pin size if set, otherwise global default
    if (temple.mapPinSize != null) {
      return temple.mapPinSize!;
    }
    return _mapSettings?.defaultPinSize ?? 42.0;
  }

  Color _parseColor(String hexColor) {
    try {
      String hex = hexColor.replaceAll('#', '');
      if (hex.length == 3) {
        hex = hex.split('').map((c) => c + c).join('');
      }
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return AppTheme.primarySaffron; // Default fallback
    }
  }

  IconData _getIconData(String iconStyle) {
    switch (iconStyle) {
      case 'place':
        return Icons.place;
      case 'temple_hindu':
        return Icons.temple_hindu;
      case 'location_pin':
        return Icons.location_pin;
      case 'my_location':
        return Icons.my_location;
      case 'flag':
        return Icons.flag;
      case 'landscape':
        return Icons.landscape;
      case 'terrain':
        return Icons.terrain;
      case 'location_on':
      default:
        return Icons.location_on;
    }
  }

  /// Get the Google Maps tile layer URL template based on map style
  String _getTileUrlTemplate(String mapStyle) {
    switch (mapStyle) {
      case 'satellite':
        return 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';
      case 'hybrid':
        return 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}';
      case 'terrain':
        return 'https://mt1.google.com/vt/lyrs=p&x={x}&y={y}&z={z}';
      case 'dark':
        // Dark mode uses standard tiles with color filter (handled in tileBuilder)
        return 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
      case 'standard':
      default:
        return 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
    }
  }

  /// Get effective map style (temple-specific not supported, uses global)
  String _getEffectiveMapStyle() {
    return _mapSettings?.mapStyle ?? 'standard';
  }

  /// Get effective tile URL template based on map style
  String _getEffectiveTileUrlTemplate() {
    return _getTileUrlTemplate(_getEffectiveMapStyle());
  }

  /// Get tile builder for dark mode
  Widget Function(BuildContext, Widget, Object)? _getTileBuilder(bool isDark, String mapStyle) {
    if (!isDark) return null;
    
    // For dark style, we apply a color filter to make tiles dark
    // For standard/satellite/terrain in dark mode, also apply dark filter
    if (mapStyle == 'dark' || isDark) {
      return (context, tileWidget, tile) {
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            -0.2126, -0.7152, -0.0722, 0, 255,
            -0.2126, -0.7152, -0.0722, 0, 255,
            -0.2126, -0.7152, -0.0722, 0, 255,
            0,       0,       0,       1, 0,
          ]),
          child: tileWidget,
        );
      };
    }
    return null;
  }

  /// Get effective location for a temple: prioritize temple's stored database coordinates
  /// saved from Admin panel, then fall back to directionsUrl extraction, then location model.
  LatLng _getEffectiveLatLng(Temple temple) {
    // 1. Prioritize temple's stored database coordinates saved from Admin panel
    final isDefault = (temple.latitude == 27.5830 && temple.longitude == 77.7000);
    if (!isDefault && temple.latitude != 0.0 && temple.longitude != 0.0) {
      return LatLng(temple.latitude, temple.longitude);
    }
    // 2. Try extracting from directionsUrl if available
    if (temple.directionsUrl != null && temple.directionsUrl!.trim().isNotEmpty) {
      final parsed = _extractLatLngFromUrl(temple.directionsUrl!.trim());
      if (parsed != null) return parsed;
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
    final mapSettingsAsync = ref.watch(mapSettingsProvider);

    return mapSettingsAsync.when(
      data: (mapSettings) {
        _mapSettings = mapSettings;
        final effectiveMapStyle = _getEffectiveMapStyle();
        final tileUrlTemplate = _getEffectiveTileUrlTemplate();
        final tileBuilder = _getTileBuilder(isDark, effectiveMapStyle);

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
              final defaultCenter = _getDefaultCenter();
              final defaultZoom = _getDefaultZoom();
              final minZoom = _getMinZoom();
              final maxZoom = _getMaxZoom();
              final validTemples = temples.where(_hasValidLocation).toList();

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
                          color: Colors.black.withValues(alpha: 0.7),
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
                      initialCenter: defaultCenter,
                      initialZoom: defaultZoom,
                      minZoom: minZoom,
                      maxZoom: maxZoom,
                      onTap: (_, __) {
                        if (_selectedTemple != null) {
                          setState(() => _selectedTemple = null);
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: tileUrlTemplate,
                        userAgentPackageName: 'com.brajdarshan.app',
                        tileBuilder: tileBuilder,
                      ),

                      MarkerLayer(
                        markers: [
                          // Render debug coordinate points under pins (only in debug mode for verification)
                          if (kDebugMode)
                            ...validTemples.map((temple) => BrajMapPinWidget.buildDebugPointMarker(_getEffectiveLatLng(temple))),

                          // Render temple map pins with mathematically precise tip alignment
                          ...validTemples.map((temple) {
                            final isSelected = _selectedTemple?.id == temple.id;
                            final effectivePos = _getEffectiveLatLng(temple);
                            final pinColor = _getEffectivePinColor(temple);
                            final pinSize = _getEffectivePinSize(temple);
                            final pinIcon = _getIconData(_getEffectivePinIconStyle(temple));

                            return BrajMapPinWidget.buildMarker(
                              point: effectivePos,
                              title: temple.name,
                              icon: pinIcon,
                              pinColor: pinColor,
                              pinSize: pinSize,
                              isSelected: isSelected,
                              onTap: () => _onMarkerTapped(temple),
                            );
                          }),
                        ],
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
                            _mapController.move(_mapController.camera.center, (currentZoom + 1).clamp(minZoom, maxZoom));
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
                            _mapController.move(_mapController.camera.center, (currentZoom - 1).clamp(minZoom, maxZoom));
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
                              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
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
                                            color: AppTheme.primarySaffron,
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              _selectedTemple!.location is Location
                                                  ? (_selectedTemple!.location as Location).name
                                                  : 'Vrindavan Dham',
                                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
      },
      loading: () => const Scaffold(
        body: LoadingSkeleton(height: 400),
      ),
      error: (err, _) => Scaffold(
        body: ErrorView(
          message: 'Failed to load map settings',
          onRetry: () => ref.refresh(mapSettingsProvider),
        ),
      ),
    );
  }
}



