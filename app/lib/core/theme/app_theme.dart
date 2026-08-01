import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryCharcoal = Color(0xFF18181B);
  static const Color canvasLight = Color(0xFFFAF9F6);
  static const Color canvasDark = Color(0xFF09090B);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF18181B);
  static const Color borderLight = Color(0xFFE4E4E7);
  static const Color borderDark = Color(0xFF27272A);
  static const Color mutedGray = Color(0xFF71717A);

  static const double borderRadius = 18.0;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: canvasLight,
    colorScheme: const ColorScheme.light(
      primary: primaryCharcoal,
      onPrimary: Colors.white,
      secondary: mutedGray,
      surface: cardLight,
      onSurface: Color(0xFF09090B),
      outline: borderLight,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: canvasLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: primaryCharcoal),
      titleTextStyle: TextStyle(
        color: primaryCharcoal,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
      ),
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: const BorderSide(color: borderLight, width: 1),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF4F4F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderLight, width: 1),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryCharcoal,
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
      secondary: mutedGray,
      surface: cardDark,
      onSurface: Colors.white,
      outline: borderDark,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: canvasDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
      ),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: const BorderSide(color: borderDark, width: 1),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF27272A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderDark, width: 1),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}
