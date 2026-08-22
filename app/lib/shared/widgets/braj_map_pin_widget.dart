import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';

/// Reusable map pin widget and marker factory for Braj Darshan maps.
/// Ensures consistent, mathematically precise GPS tip anchoring across all screens.
class BrajMapPinWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color pinColor;
  final double pinSize;
  final bool isSelected;
  final VoidCallback? onTap;

  const BrajMapPinWidget({
    super.key,
    required this.title,
    this.icon = Icons.location_on,
    this.pinColor = AppTheme.primarySaffron,
    this.pinSize = 40.0,
    this.isSelected = false,
    this.onTap,
  });

  /// Factory helper to construct a flutter_map [Marker] with perfect tip alignment.
  static Marker buildMarker({
    required LatLng point,
    required String title,
    IconData icon = Icons.location_on,
    Color pinColor = AppTheme.primarySaffron,
    double pinSize = 40.0,
    bool isSelected = false,
    VoidCallback? onTap,
    double width = 180.0,
    double height = 75.0,
  }) {
    return Marker(
      point: point,
      width: width,
      height: height,
      alignment: Alignment.bottomCenter,
      child: BrajMapPinWidget(
        title: title,
        icon: icon,
        pinColor: pinColor,
        pinSize: pinSize,
        isSelected: isSelected,
        onTap: onTap,
      ),
    );
  }

  /// Factory helper to build debug crosshair marker for verifying GPS point alignment in debug mode.
  static Marker buildDebugPointMarker(LatLng point) {
    return Marker(
      point: point,
      width: 10.0,
      height: 10.0,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.yellow, width: 2.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectivePinSize = isSelected ? pinSize * 1.15 : pinSize;

    return Semantics(
      label: 'Map Marker for $title',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isSelected ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Label Text Container (renders cleanly above the pin)
              if (title.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? pinColor
                          : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? Color.fromARGB(255, (pinColor.r * 0.7).round(), (pinColor.g * 0.7).round(), (pinColor.b * 0.7).round())
                          : const Color(0xFF1F2937),
                      fontSize: isSelected ? 12.5 : 11.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                      height: 1.15,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 3),

              // 2. Pin Icon Stack (Bottom tip corresponds exactly to Column's bottomCenter)
              SizedBox(
                width: effectivePinSize,
                height: effectivePinSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Main teardrop icon
                    Icon(
                      icon,
                      size: effectivePinSize,
                      color: pinColor,
                      shadows: const [
                        Shadow(
                          color: Color(0x40000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    // White center circle
                    Positioned(
                      top: effectivePinSize * 0.19,
                      child: Container(
                        width: effectivePinSize * 0.30,
                        height: effectivePinSize * 0.30,
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
    );
  }
}
