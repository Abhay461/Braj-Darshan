import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    const overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFAF9F6),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFAF9F6),
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: MaterialApp.router(
        title: 'Braj Darshan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
      ),
    );
  }
}
