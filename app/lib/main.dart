import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/hive_service.dart';
import 'core/services/ad_service.dart';
import 'core/services/security_check.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';



import 'shared/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  debugPrint('🚀 [MAIN] Starting app initialization...');
  
  try {
    debugPrint('📦 [MAIN] Initializing HiveService...');
    await HiveService.init();
    debugPrint('✅ [MAIN] HiveService initialized');
  } catch (e) {
    debugPrint('❌ [MAIN] HiveService error: $e');
  }

  try {
    debugPrint('📦 [MAIN] Initializing AdService...');
    await AdService.init();
    debugPrint('✅ [MAIN] AdService initialized');
  } catch (e) {
    debugPrint('❌ [MAIN] AdService error: $e');
  }

  try {
    debugPrint('📦 [MAIN] Initializing NotificationService...');
    await NotificationService().initialize();
    debugPrint('✅ [MAIN] NotificationService initialized');
  } catch (e) {
    debugPrint('❌ [MAIN] NotificationService error: $e');
  }

  // Enforce root/jailbreak detection
  try {
    debugPrint('🔒 [MAIN] Running security check...');
    await SecurityCheck.enforceDeviceSecurity();
    debugPrint('✅ [MAIN] Security check passed');
  } catch (e) {
    debugPrint('❌ [MAIN] Security check error: $e');
  }

  debugPrint('🚀 [MAIN] Running app');
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
    final isDark = themeMode == ThemeMode.dark;

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? AppTheme.sandalwoodDark : AppTheme.sandalwoodCream,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: MaterialApp.router(
        title: 'Braj Darshan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: appRouter,
      ),
    );
  }
}
