import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/hive_service.dart';
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
  return ref.watch(templeRepositoryProvider).getFeaturedTemples();
});

// All Temples Provider
final allTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  return ref.watch(templeRepositoryProvider).getTemples(limit: 50);
});

// Popular Temples Provider
final popularTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  return ref.watch(templeRepositoryProvider).getPopularTemples();
});

// Recent Temples Provider
final recentTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  return ref.watch(templeRepositoryProvider).getRecentTemples();
});

// Categories Provider
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.watch(templeRepositoryProvider).getCategories();
});

// Locations Provider
final locationsProvider = FutureProvider<List<Location>>((ref) async {
  return ref.watch(templeRepositoryProvider).getLocations();
});

// Festivals Provider
final festivalsProvider = FutureProvider<List<Festival>>((ref) async {
  return ref.watch(templeRepositoryProvider).getFestivals();
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

// Favorites Notifier (Hive Sync)
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super(HiveService.getFavoriteIds());

  void toggleFavorite(String templeId) {
    HiveService.toggleFavorite(templeId);
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
    if (mode == 'light') return ThemeMode.light;
    if (mode == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
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
  AppLanguageNotifier() : super('en');

  void setLanguage(String langCode) {
    state = langCode;
  }
}

final appLanguageProvider = StateNotifierProvider<AppLanguageNotifier, String>((ref) {
  return AppLanguageNotifier();
});
