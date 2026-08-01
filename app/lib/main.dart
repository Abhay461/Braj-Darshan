import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/hive_service.dart';
import 'core/services/ad_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'shared/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await HiveService.init();
  } catch (e) {
    debugPrint('HiveService initialization error: $e');
  }

  try {
    await AdService.init();
  } catch (e) {
    debugPrint('AdService initialization error: $e');
  }

  runApp(
    const ProviderScope(
      child: BrajDarshanApp(),
    ),
  );
}

class BrajDarshanApp extends ConsumerWidget {
  const BrajDarshanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Braj Darshan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
