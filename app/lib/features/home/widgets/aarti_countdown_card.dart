import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/providers/providers.dart';

class AartiCountdownCard extends ConsumerWidget {
  const AartiCountdownCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aartiAsync = ref.watch(aartiCountdownProvider);
    
    return aartiAsync.when(
      data: (aartiData) {
        if (aartiData == null) return const SizedBox.shrink();
        return _AartiCountdownCardContent(data: aartiData);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _AartiCountdownCardContent extends ConsumerStatefulWidget {
  final AartiCountdownData data;
  
  const _AartiCountdownCardContent({required this.data});
  
  @override
  ConsumerState<_AartiCountdownCardContent> createState() => _AartiCountdownCardContentState();
}

class _AartiCountdownCardContentState extends ConsumerState<_AartiCountdownCardContent> {
  late Duration _timeRemaining;
  late bool _isTomorrow;
  
  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.data.timeRemaining;
    _isTomorrow = widget.data.isTomorrow;
    
    // Update countdown every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (!_isTomorrow && _timeRemaining.inSeconds > 0) {
          _timeRemaining = Duration(seconds: _timeRemaining.inSeconds - 1);
        }
        if (_timeRemaining.inSeconds <= 0 && !_isTomorrow) {
          // Aarti time has passed, refetch will happen via stream
          _timeRemaining = Duration.zero;
        }
      });
      return true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = widget.data;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
child: Semantics(
        label: 'Upcoming Aarti: ${data.aarti.name} at ${data.temple.name} in ${_formatCountdown}',
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
onTap: () {
              context.push('/temple/${data.temple.id}');
            },
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppTheme.primarySaffronDark.withValues(alpha: 0.15), AppTheme.secondarySaffronDark.withValues(alpha: 0.1)]
                      : [AppTheme.primarySaffron.withValues(alpha: 0.12), AppTheme.secondarySaffron.withValues(alpha: 0.08)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                border: Border.all(
                  color: isDark 
                      ? AppTheme.primarySaffronDark.withValues(alpha: 0.3)
                      : AppTheme.primarySaffron.withValues(alpha: 0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                        ? AppTheme.primarySaffronDark.withValues(alpha: 0.1)
                        : AppTheme.primarySaffron.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Aarti Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.primarySaffronDark.withValues(alpha: 0.2)
                          : AppTheme.primarySaffron.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.access_time_outlined,
                      color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Temple Name
                        Text(
                          data.temple.name,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 2),
                        
                        // Aarti Name and Countdown
                        Row(
                          children: [
Expanded(
                              child: Text(
                                '${data.aarti.name} ${_isTomorrow ? "(Tomorrow)" : ""}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Countdown Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.primarySaffronDark.withValues(alpha: 0.2)
                                    : AppTheme.primarySaffron.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.primarySaffronDark.withValues(alpha: 0.3)
                                      : AppTheme.primarySaffron.withValues(alpha: 0.25),
                                  width: 0.5,
                                ),
                              ),
child: Text(
                                '${_formatCountdown}',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppTheme.primarySaffronDark : AppTheme.primarySaffron,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Chevron
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
String get _formatCountdown {
    if (_isTomorrow) return 'Tomorrow';
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;
    if (hours > 0) return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
