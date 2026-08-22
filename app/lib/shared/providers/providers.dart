import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import '../../core/network/dio_client.dart';
import '../../core/services/hive_service.dart';
import '../../core/services/weather_service.dart';
import '../models/models.dart';
import '../repositories/temple_repository.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final templeRepositoryProvider = Provider<TempleRepository>((ref) {
  return TempleRepository(dioClient: ref.watch(dioClientProvider));
});

// Featured Temples Provider
final featuredTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  debugPrint('📡 [PROVIDER] Fetching featured temples...');
  final result = await ref.watch(templeRepositoryProvider).getFeaturedTemples();
  debugPrint('✅ [PROVIDER] Featured temples loaded: ${result.length}');
  return result;
});

// All Temples Provider
final allTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  debugPrint('📡 [PROVIDER] Fetching all temples...');
  final result = await ref.watch(templeRepositoryProvider).getTemples(limit: 50);
  debugPrint('✅ [PROVIDER] All temples loaded: ${result.length}');
  return result;
});

// Popular Temples Provider
final popularTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  debugPrint('📡 [PROVIDER] Fetching popular temples...');
  final result = await ref.watch(templeRepositoryProvider).getPopularTemples();
  debugPrint('✅ [PROVIDER] Popular temples loaded: ${result.length}');
  return result;
});

// Recent Temples Provider
final recentTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  debugPrint('📡 [PROVIDER] Fetching recent temples...');
  final result = await ref.watch(templeRepositoryProvider).getRecentTemples();
  debugPrint('✅ [PROVIDER] Recent temples loaded: ${result.length}');
  return result;
});

// Categories Provider
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  debugPrint('📡 [PROVIDER] Fetching categories...');
  final result = await ref.watch(templeRepositoryProvider).getCategories();
  debugPrint('✅ [PROVIDER] Categories loaded: ${result.length}');
  return result;
});

// Locations Provider
final locationsProvider = FutureProvider<List<Location>>((ref) async {
  debugPrint('📡 [PROVIDER] Fetching locations...');
  final result = await ref.watch(templeRepositoryProvider).getLocations();
  debugPrint('✅ [PROVIDER] Locations loaded: ${result.length}');
  return result;
});

// Festivals Provider
final festivalsProvider = FutureProvider<List<Festival>>((ref) async {
  debugPrint('📡 [PROVIDER] Fetching festivals...');
  final result = await ref.watch(templeRepositoryProvider).getFestivals();
  debugPrint('✅ [PROVIDER] Festivals loaded: ${result.length}');
  return result;
});

// Map Settings Provider
final mapSettingsProvider = FutureProvider<MapSettings?>((ref) async {
  return ref.watch(templeRepositoryProvider).getMapSettings();
});

// ─── Aarti Countdown Provider ───────────────────────────────────────

class AartiCountdownData {
  final Temple temple;
  final AartiTiming aarti;
  final Duration timeRemaining;
  final bool isTomorrow;
  final DateTime nextAartiDateTime;

  AartiCountdownData({
    required this.temple,
    required this.aarti,
    required this.timeRemaining,
    required this.isTomorrow,
    required this.nextAartiDateTime,
  });

String get formattedCountdown {
    if (isTomorrow) {
      return 'Tomorrow at ${aarti.time}';
    }
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    final seconds = timeRemaining.inSeconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m ${seconds}s';
  }
}

final aartiCountdownProvider = StreamProvider<AartiCountdownData?>((ref) async* {
  final repository = ref.watch(templeRepositoryProvider);
  final allTemples = await repository.getTemples(limit: 100);
  
  // Collect all valid aarti timings from all temples
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  
  List<AartiCountdownData> allAartis = [];
  
  for (final temple in allTemples) {
    if (temple.aartiTimings.isEmpty) continue;
    
    for (final aarti in temple.aartiTimings) {
      final timeParts = aarti.time.split(':');
      if (timeParts.length != 2) continue;
      
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null || hour < 0 || hour > 23 || minute < 0 || minute > 59) continue;
      
      // Check today
      final todayAarti = DateTime(now.year, now.month, now.day, hour, minute);
      if (todayAarti.isAfter(now)) {
        allAartis.add(AartiCountdownData(
          temple: temple,
          aarti: aarti,
          timeRemaining: todayAarti.difference(now),
          isTomorrow: false,
          nextAartiDateTime: todayAarti,
        ));
      }
      
      // Check tomorrow
      final tomorrowAarti = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);
      allAartis.add(AartiCountdownData(
        temple: temple,
        aarti: aarti,
        timeRemaining: tomorrowAarti.difference(now),
        isTomorrow: true,
        nextAartiDateTime: tomorrowAarti,
      ));
    }
  }
  
  if (allAartis.isEmpty) {
    yield null;
    return;
  }
  
  // Sort by timeRemaining (nearest first)
  allAartis.sort((a, b) => a.timeRemaining.compareTo(b.timeRemaining));
  
  // Emit the nearest upcoming aarti
  yield allAartis.first;
  
  // Update every minute
  await for (final _ in Stream.periodic(const Duration(minutes: 1))) {
    final currentNow = DateTime.now();
    final currentToday = DateTime(currentNow.year, currentNow.month, currentNow.day);
    final currentTomorrow = currentToday.add(const Duration(days: 1));
    
    List<AartiCountdownData> currentAartis = [];
    
    for (final temple in allTemples) {
      if (temple.aartiTimings.isEmpty) continue;
      
      for (final aarti in temple.aartiTimings) {
        final timeParts = aarti.time.split(':');
        if (timeParts.length != 2) continue;
        
        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);
        if (hour == null || minute == null || hour < 0 || hour > 23 || minute < 0 || minute > 59) continue;
        
        // Check today
        final todayAarti = DateTime(currentNow.year, currentNow.month, currentNow.day, hour, minute);
        if (todayAarti.isAfter(currentNow)) {
          currentAartis.add(AartiCountdownData(
            temple: temple,
            aarti: aarti,
            timeRemaining: todayAarti.difference(currentNow),
            isTomorrow: false,
            nextAartiDateTime: todayAarti,
          ));
        }
        
        // Check tomorrow
        final tomorrowAarti = DateTime(currentTomorrow.year, currentTomorrow.month, currentTomorrow.day, hour, minute);
        currentAartis.add(AartiCountdownData(
          temple: temple,
          aarti: aarti,
          timeRemaining: tomorrowAarti.difference(currentNow),
          isTomorrow: true,
          nextAartiDateTime: tomorrowAarti,
        ));
      }
    }
    
    if (currentAartis.isEmpty) {
      yield null;
      continue;
    }
    
    currentAartis.sort((a, b) => a.timeRemaining.compareTo(b.timeRemaining));
    yield currentAartis.first;
  }
});

// ─── Weather Provider ───────────────────────────────────────────────

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

final weatherProvider = FutureProvider<WeatherData?>((ref) async {
  final service = ref.watch(weatherServiceProvider);
  return service.fetchWeather();
});

// ─── Emergency Contacts Provider ────────────────────────────────────

final emergencyContactsProvider = FutureProvider<List<EmergencyContact>>((ref) async {
  final repository = ref.watch(templeRepositoryProvider);
  try {
    final response = await repository.dioClient.dio.get('/emergency-contacts');
    if (response.data['success'] == true && response.data['data'] != null) {
      final List rawList = response.data['data']['data'] ?? response.data['data'];
      return rawList.map((item) => EmergencyContact.fromJson(item)).toList();
    }
} catch (e) {
      developer.log('EmergencyContactsProvider error: $e');
    }
  return [];
});

// ─── Festival Theme Provider ────────────────────────────────────────

final activeFestivalThemeProvider = Provider<FestivalThemeConfig?>((ref) {
  final festivalsAsync = ref.watch(festivalsProvider);
  return festivalsAsync.when(
    data: (festivals) {
      for (final festival in festivals) {
        if (festival.isCurrentlyActive && festival.themeConfig != null) {
          return festival.themeConfig!;
        }
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// ─── Current Active Festival Provider ──────────────────────────────

final activeFestivalProvider = Provider<Festival?>((ref) {
  final festivalsAsync = ref.watch(festivalsProvider);
  return festivalsAsync.when(
    data: (festivals) {
      for (final festival in festivals) {
        if (festival.isCurrentlyActive) {
          return festival;
        }
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Search Query & Filter Notifier
class SearchQuery {
  final String text;
  final String? categoryId;
  final String? locationId;

  SearchQuery({this.text = '', this.categoryId, this.locationId});
}

final searchQueryProvider = StateProvider<SearchQuery>((ref) => SearchQuery());

final searchTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(templeRepositoryProvider).getTemples(
        search: query.text,
        categoryId: query.categoryId,
        locationId: query.locationId,
      );
});

// Temple Detail Provider Family
final templeDetailProvider = FutureProvider.family<Temple?, String>((ref, idOrSlug) async {
  return ref.watch(templeRepositoryProvider).getTempleByIdOrSlug(idOrSlug);
});

// Favorites Notifier (Hive Sync)
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super(HiveService.getFavoriteIds());

  Future<void> toggleFavorite(String templeId) async {
    await HiveService.toggleFavorite(templeId);
    state = HiveService.getFavoriteIds();
  }

  bool isFavorite(String templeId) {
    return state.contains(templeId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

// Theme Notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    final mode = HiveService.getThemeMode();
    if (mode == 'dark') return ThemeMode.dark;
    if (mode == 'system') return ThemeMode.system;
    return ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    HiveService.setThemeMode(mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system');
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// App Language Notifier ('en' | 'hi')
class AppLanguageNotifier extends StateNotifier<String> {
  AppLanguageNotifier() : super(HiveService.getLanguage());

  void setLanguage(String langCode) {
    state = langCode;
    HiveService.setLanguage(langCode);
  }
}

final appLanguageProvider = StateNotifierProvider<AppLanguageNotifier, String>((ref) {
  return AppLanguageNotifier();
});
