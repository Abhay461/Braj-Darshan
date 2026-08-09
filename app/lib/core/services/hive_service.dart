import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/constants.dart';

class HiveService {
  static const _secureStorage = FlutterSecureStorage();

  static Future<Uint8List> _getEncryptionKey() async {
    final existingKey = await _secureStorage.read(key: 'hive_enc_key');
    if (existingKey != null) {
      return Uint8List.fromList(base64Url.decode(existingKey));
    }
    final key = Hive.generateSecureKey();
    await _secureStorage.write(key: 'hive_enc_key', value: base64UrlEncode(key));
    return Uint8List.fromList(key);
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    final encryptionKey = await _getEncryptionKey();
    await Hive.openBox<String>(AppConstants.favoritesBox, encryptionCipher: HiveAesCipher(encryptionKey));
    await Hive.openBox<String>(AppConstants.recentSearchesBox, encryptionCipher: HiveAesCipher(encryptionKey));
    await Hive.openBox<dynamic>(AppConstants.settingsBox, encryptionCipher: HiveAesCipher(encryptionKey));
    await Hive.openBox<String>(AppConstants.yatraPlansBox, encryptionCipher: HiveAesCipher(encryptionKey));
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

  // Yatra Plans Storage
  static Box<String> get yatraPlansBox => Hive.box<String>(AppConstants.yatraPlansBox);

  static List<String> getYatraPlansRaw() {
    return yatraPlansBox.values.toList();
  }

  static Future<void> saveYatraPlanRaw(String planId, String jsonString) async {
    await yatraPlansBox.put(planId, jsonString);
  }

  static Future<void> deleteYatraPlanRaw(String planId) async {
    await yatraPlansBox.delete(planId);
  }

  static Future<void> clearYatraPlans() async {
    await yatraPlansBox.clear();
  }
}
