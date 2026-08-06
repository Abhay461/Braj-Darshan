import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/providers.dart';
import '../../core/config/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLanguage = ref.watch(appLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dark Mode Switch
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isDark ? 'ON' : 'OFF',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isDark,
                      activeColor: Theme.of(context).colorScheme.onPrimary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveThumbColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      inactiveTrackColor: Theme.of(context).colorScheme.outline,
                      onChanged: (bool enabled) {
                        HapticFeedback.lightImpact();
                        ref.read(themeModeProvider.notifier).setTheme(enabled ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Language Selection Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.language_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Language',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),

              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Text('English', style: Theme.of(context).textTheme.bodyMedium),
                value: 'en',
                groupValue: currentLanguage,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (val) {
                  if (val != null) {
                    HapticFeedback.selectionClick();
                    ref.read(appLanguageProvider.notifier).setLanguage(val);
                  }
                },
              ),

              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Text('हिंदी (Hindi)', style: Theme.of(context).textTheme.bodyMedium),
                value: 'hi',
                groupValue: currentLanguage,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (val) {
                  if (val != null) {
                    HapticFeedback.selectionClick();
                    ref.read(appLanguageProvider.notifier).setLanguage(val);
                  }
                },
              ),

              const SizedBox(height: 12),

              // 3. About Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Text(
                      'v${AppConstants.appVersion}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
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

