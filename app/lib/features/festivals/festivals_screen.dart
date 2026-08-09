import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_view.dart';
import '../../core/theme/app_theme.dart';

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
    final festivalsAsync = ref.watch(festivalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Braj Utsav & Festivals',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: festivalsAsync.when(
        data: (festivals) {
          if (festivals.isEmpty) {
            return Center(
              child: Text(
                'No upcoming festivals listed',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
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
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Festival Devotional Saffron Badge Highlight
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.saffronHighlight.withOpacity( 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.saffronHighlight.withOpacity( 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.event_outlined,
                              size: 18,
                              color: AppTheme.saffronHighlight,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              monthBadge,
                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppTheme.saffronHighlight,
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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              descText,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7),
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

