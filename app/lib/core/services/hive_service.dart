import 'package:hive_flutter/hive_flutter.dart';
import '../config/constants.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(AppConstants.favoritesBox);
    await Hive.openBox<String>(AppConstants.recentSearchesBox);
    await Hive.openBox<dynamic>(AppConstants.settingsBox);
  }

  // Favorites Storage
  static Box<String> get favoritesBox => Hive.box<String>(AppConstants.favoritesBox);

  static bool isFavorite(String templeId) {
    return favoritesBox.containsKey(templeId);
  }

  static Future<void> toggleFavorite(String templeId) async {
    if (isFavorite(templeId)) {
      await favoritesBox.delete(templeId);
    } else {
      await favoritesBox.put(templeId, templeId);
    }
  }

  static List<String> getFavoriteIds() {
    return favoritesBox.values.toList();
  }

  // Settings Storage
  static Box<dynamic> get settingsBox => Hive.box<dynamic>(AppConstants.settingsBox);

  static String getThemeMode() {
    return settingsBox.get('theme_mode', defaultValue: 'system');
  }

  static Future<void> setThemeMode(String mode) async {
    await settingsBox.put('theme_mode', mode);
  }

  static String getLanguage() {
    return settingsBox.get('language', defaultValue: 'en');
  }

  static Future<void> setLanguage(String lang) async {
    await settingsBox.put('language', lang);
  }
}
