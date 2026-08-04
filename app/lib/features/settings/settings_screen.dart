import 'package:flutter/material.dart';
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
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF141417) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? const Color(0x30000000) : const Color(0x0A000000),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dark Mode Switch (No Divider Line)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode_outlined,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF18181B),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Dark Mode',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : const Color(0xFF18181B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isDark ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.black : Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isDark,
                      activeColor: isDark ? Colors.black : Colors.white,
                      activeTrackColor: isDark ? Colors.white : const Color(0xFF18181B),
                      inactiveThumbColor: const Color(0xFF71717A),
                      inactiveTrackColor: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                      onChanged: (bool enabled) {
                        ref.read(themeModeProvider.notifier).setTheme(enabled ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Language Selection Header (No Divider Line)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.language_outlined,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF18181B),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Language',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),

              // English Radio Option
              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                dense: true,
                title: const Text('English', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                value: 'en',
                groupValue: currentLanguage,
                activeColor: isDark ? Colors.white : const Color(0xFF18181B),
                onChanged: (val) {
                  if (val != null) ref.read(appLanguageProvider.notifier).setLanguage(val);
                },
              ),

              // Hindi Radio Option
              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                dense: true,
                title: const Text('हिंदी (Hindi)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                value: 'hi',
                groupValue: currentLanguage,
                activeColor: isDark ? Colors.white : const Color(0xFF18181B),
                onChanged: (val) {
                  if (val != null) ref.read(appLanguageProvider.notifier).setLanguage(val);
                },
              ),

              const SizedBox(height: 12),

              // 3. About Section (No Divider Line)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF18181B),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF18181B),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'v${AppConstants.appVersion}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF71717A), fontWeight: FontWeight.w600),
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
