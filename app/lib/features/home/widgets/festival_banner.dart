import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/providers/providers.dart';

class FestivalBanner extends ConsumerWidget {
  const FestivalBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festival = ref.watch(activeFestivalProvider);
    final themeConfig = ref.watch(activeFestivalThemeProvider);
    
    if (festival == null) return const SizedBox.shrink();
    
    return _FestivalBannerContent(
      festival: festival,
      themeConfig: themeConfig,
    );
  }
}

class _FestivalBannerContent extends StatelessWidget {
  final Festival festival;
  final FestivalThemeConfig? themeConfig;
  
  const _FestivalBannerContent({
    required this.festival,
    this.themeConfig,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = themeConfig?.accentColor != null && themeConfig!.accentColor!.isNotEmpty
        ? Color(int.parse(themeConfig!.accentColor!.replaceFirst('#', '0xFF')))
        : (isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron);
    
    final showPetals = themeConfig?.showPetals ?? false;
    final petalType = themeConfig?.petalType ?? 'none';
    
    // Determine petal animation
    final bool animatePetals = showPetals && petalType != 'none';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          // Main Banner
Semantics(
            label: 'Festival: ${festival.name}. ${festival.description ?? ""}',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          accentColor.withValues(alpha: 0.18),
                          accentColor.withValues(alpha: 0.08),
                        ]
                      : [
                          accentColor.withValues(alpha: 0.12),
                          accentColor.withValues(alpha: 0.05),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Festival Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: isDark ? 0.25 : 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.celebration_outlined,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Festival Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          festival.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (festival.startDate != null && festival.endDate != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            _formatFestivalDates(festival.startDate!, festival.endDate!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: accentColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (festival.description != null && festival.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            festival.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: 12,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Optional Banner Image
                  if (themeConfig?.bannerImage != null && themeConfig!.bannerImage!.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        themeConfig!.bannerImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Petal Animation Overlay (lightweight)
          if (animatePetals)
            _PetalOverlay(
              petalType: petalType,
              accentColor: accentColor,
            ),
        ],
      ),
    );
  }
  
String _formatFestivalDates(String start, String end) {
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      
      if (startDate.year == endDate.year && startDate.month == endDate.month && startDate.day == endDate.day) {
        return '${months[startDate.month - 1]} ${startDate.day}, ${startDate.year}';
      }
      if (startDate.month == endDate.month && startDate.year == endDate.year) {
        return '${months[startDate.month - 1]} ${startDate.day}-${endDate.day}, ${startDate.year}';
      }
      return '${months[startDate.month - 1]} ${startDate.day} - ${months[endDate.month - 1]} ${endDate.day}, ${endDate.year}';
    } catch (_) {
      return ' - ';
    }
  }
}

class _PetalOverlay extends StatefulWidget {
  final String petalType;
  final Color accentColor;
  
  const _PetalOverlay({
    required this.petalType,
    required this.accentColor,
  });
  
  @override
  State<_PetalOverlay> createState() => _PetalOverlayState();
}

class _PetalOverlayState extends State<_PetalOverlay> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Petal> _petals = [];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    // Generate petals (max 15 for performance)
    for (int i = 0; i < 15; i++) {
      _petals.add(_Petal(
        type: widget.petalType,
        color: widget.accentColor,
        startX: (i * 0.07) % 1.0,
        speed: 0.5 + (i % 3) * 0.3,
        size: 8.0 + (i % 4) * 3.0,
        delay: (i * 0.5) % 1.0,
      ));
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _PetalPainter(
            petals: _petals,
            progress: _controller.value,
            petalType: widget.petalType,
            color: widget.accentColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Petal {
  final String type;
  final Color color;
  final double startX;
  final double speed;
  final double size;
  final double delay;
  
  _Petal({
    required this.type,
    required this.color,
    required this.startX,
    required this.speed,
    required this.size,
    required this.delay,
  });
}

class _PetalPainter extends CustomPainter {
  final List<_Petal> petals;
  final double progress;
  final String petalType;
  final Color color;
  
  _PetalPainter({
    required this.petals,
    required this.progress,
    required this.petalType,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final petal in petals) {
      final adjustedProgress = (progress + petal.delay) % 1.0;
      final y = size.height * (1.0 - adjustedProgress * petal.speed);
      
      if (y > -petal.size && y < size.height + petal.size) {
        final x = size.width * ((petal.startX + adjustedProgress * 0.1) % 1.0);
        
        final paint = Paint()..color = color.withValues(alpha: 0.6 - adjustedProgress * 0.3);
        
        _drawPetal(canvas, x, y, petal.size, paint);
      }
    }
  }
  
  void _drawPetal(Canvas canvas, double x, double y, double size, Paint paint) {
    final path = Path();
    
    switch (petalType) {
      case 'gulal':
        // Small colored circles for gulal
        canvas.drawCircle(Offset(x, y), size * 0.5, paint);
        break;
      case 'flower':
        // Flower petal shape (4 petals)
        for (int i = 0; i < 4; i++) {
          final angle = (i * 90) * 3.14159 / 180;
          final petalPath = Path();
          petalPath.addOval(Rect.fromCenter(
            center: Offset(
              x + size * 0.6 * cos(angle),
              y + size * 0.6 * sin(angle),
            ),
            width: size,
            height: size * 0.5,
          ));
          canvas.drawPath(petalPath, paint);
        }
        break;
      case 'diya':
        // Diya (lamp) shape - simple flame
        path.moveTo(x, y);
        path.quadraticBezierTo(x - size * 0.3, y - size * 0.8, x, y - size * 1.2);
        path.quadraticBezierTo(x + size * 0.3, y - size * 0.8, x, y);
        path.close();
        canvas.drawPath(path, paint);
        // Base
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, y + size * 0.3), width: size * 0.8, height: size * 0.4),
            Radius.circular(size * 0.2),
          ),
          paint,
        );
        break;
      default:
        canvas.drawCircle(Offset(x, y), size * 0.5, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _PetalPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Helper for cos/sin
double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians);
