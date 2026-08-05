import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Braj Darshan — System Theme & Color Tokens
class AppTheme {
  // Color Tokens
  static const Color primaryCharcoal = Color(0xFF18181B); // Charcoal Black
  static const Color secondaryIndigo = Color(0xFF5E5CE6); // Royal Indigo
  static const Color accentSkyBlue = Color(0xFF0EA5E9);   // Sky Blue
  static const Color canvasLight = Color(0xFFFAF9F6);     // Off-white canvas
  static const Color canvasDark = Color(0xFF09090B);      // Pure dark obsidian
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF141417);
  static const Color borderLight = Color(0xFFE5E7EB);     // Clean Gray Border
  static const Color borderDark = Color(0xFF27272A);
  static const Color mutedGray = Color(0xFF71717A);

  // System Design Tokens
  static const double borderRadius = 18.0;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: canvasLight,
    colorScheme: const ColorScheme.light(
      primary: primaryCharcoal,
      onPrimary: Colors.white,
      secondary: secondaryIndigo,
      tertiary: accentSkyBlue,
      surface: cardLight,
      onSurface: primaryCharcoal,
      outline: borderLight,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: canvasLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: primaryCharcoal, size: 22),
      titleTextStyle: TextStyle(
        color: primaryCharcoal,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
        letterSpacing: -0.4,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: const BorderSide(color: borderLight, width: 1),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderLight, width: 1),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryCharcoal,
        fontFamily: 'Inter',
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryCharcoal, width: 1.5),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: canvasDark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: primaryCharcoal,
      secondary: secondaryIndigo,
      tertiary: accentSkyBlue,
      surface: cardDark,
      onSurface: Colors.white,
      outline: borderDark,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: canvasDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white, size: 22),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
        letterSpacing: -0.4,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: const BorderSide(color: borderDark, width: 1),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cardDark,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderDark, width: 1),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
    ),
  );
}
