import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/providers.dart';
import '../../core/config/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Appearance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF71717A))),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (val) => ref.read(themeModeProvider.notifier).setTheme(val!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light Theme'),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (val) => ref.read(themeModeProvider.notifier).setTheme(val!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Theme'),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (val) => ref.read(themeModeProvider.notifier).setTheme(val!),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('About Platform', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF71717A))),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Application Version'),
                  subtitle: Text('${AppConstants.appName} v${AppConstants.appVersion}'),
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
