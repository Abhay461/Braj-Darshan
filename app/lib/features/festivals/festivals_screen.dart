import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';

class FestivalsScreen extends ConsumerWidget {
  const FestivalsScreen({super.key});

  String _deriveMonthLabel(String? startDate) {
    if (startDate == null || startDate.trim().isEmpty) {
      return 'UTSAV';
    }
    try {
      final dt = DateTime.parse(startDate.trim());
      const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
      return months[dt.month - 1];
    } catch (_) {
      final str = startDate.trim();
      return str.length >= 3 ? str.substring(0, 3).toUpperCase() : 'UTSAV';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final festivalsAsync = ref.watch(festivalsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Braj Utsav & Festivals'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      ),
      body: festivalsAsync.when(
        data: (festivals) {
          if (festivals.isEmpty) {
            return const Center(child: Text('No upcoming festivals listed'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: festivals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final fest = festivals[index];
              final monthBadge = _deriveMonthLabel(fest.startDate);
              final hasDesc = fest.description?.isNotEmpty ?? false;
              final descText = hasDesc ? fest.description! : 'Celebrated across all Braj temples with grand aarti & bhog.';

              return Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141417) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? const Color(0x20000000) : const Color(0x06000000),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Timeline Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF27272A) : const Color(0xFFF4F4F5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: isDark ? Colors.white : const Color(0xFF18181B),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              monthBadge,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF18181B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fest.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF18181B),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              descText,
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
            },
          ).animate().fadeIn(duration: 300.ms);
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              LoadingSkeleton(height: 90),
              SizedBox(height: 12),
              LoadingSkeleton(height: 90),
            ],
          ),
        ),
        error: (err, _) => ErrorView(
          message: 'Failed to load festivals',
          onRetry: () => ref.refresh(festivalsProvider),
        ),
      ),
    );
  }
}
