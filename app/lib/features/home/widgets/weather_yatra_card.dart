import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/providers/providers.dart';

class WeatherYatraCard extends ConsumerWidget {
  const WeatherYatraCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return weatherAsync.when(
      data: (weather) {
        if (weather == null) return _WeatherErrorCard(onRetry: () => ref.refresh(weatherProvider));
        return _WeatherYatraCardContent(weather: weather);
      },
      loading: () => _WeatherSkeleton(isDark: isDark),
      error: (_, __) => _WeatherErrorCard(onRetry: () => ref.refresh(weatherProvider)),
    );
  }
}

class _WeatherYatraCardContent extends StatelessWidget {
  final WeatherData weather;
  
  const _WeatherYatraCardContent({required this.weather});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Determine colors based on suggestion type
    Color suggestionColor;
    IconData suggestionIcon;
    
    switch (weather.suggestionType) {
      case 'rain':
        suggestionColor = Colors.blue.shade700;
        suggestionIcon = Icons.umbrella_outlined;
        break;
      case 'heat':
        suggestionColor = Colors.red.shade700;
        suggestionIcon = Icons.wb_sunny_outlined;
        break;
      case 'warm':
        suggestionColor = Colors.orange.shade700;
        suggestionIcon = Icons.wb_sunny_outlined;
        break;
case 'fog':
        suggestionColor = Colors.grey.shade700;
        suggestionIcon = Icons.cloud_outlined;
        break;
      case 'cool':
        suggestionColor = Colors.indigo.shade700;
        suggestionIcon = Icons.ac_unit_outlined;
        break;
      default:
        suggestionColor = Colors.green.shade700;
        suggestionIcon = Icons.check_circle_outline;
    }
    
    final lightSuggestionColor = isDark 
        ? suggestionColor.withValues(alpha: 0.2)
        : suggestionColor.withValues(alpha: 0.1);
    final borderSuggestionColor = isDark
        ? suggestionColor.withValues(alpha: 0.3)
        : suggestionColor.withValues(alpha: 0.2);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
child: Semantics(
        label: 'Weather in ${weather.locationName}: ${weather.temperature}°C, ${weather.description}. Yatra suggestion: ${weather.yatraSuggestion}',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [lightSuggestionColor, lightSuggestionColor.withValues(alpha: 0.5)]
                  : [lightSuggestionColor, lightSuggestionColor.withValues(alpha: 0.5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: borderSuggestionColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Temperature & Location
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
Flexible(
                          child: Text(
                            '${weather.locationName}, ${weather.country}',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (weather.fromCache) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              weather.cacheExpired ? 'Cached (Old)' : 'Cached',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
Text(
                          '${weather.temperature}°',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 32,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            weather.condition,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 3),
Text(
                          '${weather.humidity}% humidity',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.air_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 3),
Text(
                          '${weather.windSpeed} km/h',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Weather Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                      : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    weather.weatherIconUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      _getWeatherIcon(weather.condition),
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Yatra Suggestion
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: lightSuggestionColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderSuggestionColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: suggestionColor.withValues(alpha: isDark ? 0.2 : 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          suggestionIcon,
                          color: suggestionColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Yatra Alert',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: suggestionColor,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              weather.yatraSuggestion,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.3,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
  
IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain') || lower.contains('drizzle')) return Icons.grain_outlined;
    if (lower.contains('thunder')) return Icons.flash_on_outlined;
    if (lower.contains('snow')) return Icons.ac_unit_outlined;
    if (lower.contains('fog') || lower.contains('mist') || lower.contains('haze')) return Icons.cloud_outlined;
    if (lower.contains('cloud')) return Icons.cloud_outlined;
    return Icons.wb_sunny_outlined;
  }
}

class _WeatherSkeleton extends StatelessWidget {
  final bool isDark;
  
  const _WeatherSkeleton({required this.isDark});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.cardDark.withValues(alpha: 0.5)
              : AppTheme.sandalwoodCream.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _WeatherErrorCard extends StatelessWidget {
  final VoidCallback onRetry;
  
  const _WeatherErrorCard({required this.onRetry});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.cardDark
              : AppTheme.creamWhite,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Weather unavailable',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primarySaffron,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
