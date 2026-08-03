import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'Braj Darshan';
  static const String appVersion = '1.0.0';

  static String customApiUrl = '';
  static const String productionApiUrl = 'https://braj-darshan-wdw9.onrender.com/api/v1';

  // Base API URL with Production, Custom, and Emulator Fallbacks
  static String get apiBaseUrl {
    if (customApiUrl.isNotEmpty) return customApiUrl;
    return productionApiUrl;
  }

  // Vrindavan Default Coordinates
  static const double defaultLat = 27.5830;
  static const double defaultLng = 77.7000;

  // Hive Box Names
  static const String favoritesBox = 'braj_favorites_box';
  static const String recentSearchesBox = 'braj_recent_searches_box';
  static const String settingsBox = 'braj_settings_box';

  // AdMob Production & Test Unit IDs
  static const bool _isProductionAd = kReleaseMode;
  static String get bannerAdUnitId => _isProductionAd
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  static String get interstitialAdUnitId => _isProductionAd
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';
}
