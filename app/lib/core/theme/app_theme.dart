import 'package:flutter/material.dart';

/// Braj Darshan v2.0 — Design System
/// Apple + Notion + Linear inspired monochrome design language.
class AppTheme {
  // Monochrome Color Palette
  static const Color primaryCharcoal = Color(0xFF18181B); // Zinc 900
  static const Color pureBlack = Color(0xFF09090B);        // Zinc 950
  static const Color canvasLight = Color(0xFFFAFAFA);      // Zinc 50
  static const Color canvasDark = Color(0xFF09090B);       // Zinc 950
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF141417);
  static const Color borderLight = Color(0xFFE4E4E7);      // Zinc 200
  static const Color borderDark = Color(0xFF27272A);       // Zinc 800
  static const Color mutedGray = Color(0xFF71717A);        // Zinc 500
  static const Color lightGrayBg = Color(0xFFF4F4F5);      // Zinc 100
  static const Color darkGrayBg = Color(0xFF1E1E22);

  // System Design Tokens
  static const double borderRadius = 18.0;
  static const double minTouchTarget = 48.0;

  // Soft Elevation Shadows
  static const List<BoxShadow> softShadowLight = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x04000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> softShadowDark = [
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: canvasLight,
    colorScheme: const ColorScheme.light(
      primary: primaryCharcoal,
      onPrimary: Colors.white,
      secondary: mutedGray,
      surface: cardLight,
      onSurface: pureBlack,
      outline: borderLight,
      surfaceContainerHighest: lightGrayBg,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: canvasLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: primaryCharcoal, size: 22),
      titleTextStyle: TextStyle(
        color: primaryCharcoal,
        fontSize: 18,
        fontWeight: FontWeight.w700,
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
      backgroundColor: lightGrayBg,
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
      hintStyle: const TextStyle(
        color: mutedGray,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: borderLight,
      thickness: 1,
      space: 1,
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
      surfaceContainerHighest: darkGrayBg,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: canvasDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white, size: 22),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
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
      backgroundColor: darkGrayBg,
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
      hintStyle: const TextStyle(
        color: mutedGray,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: borderDark,
      thickness: 1,
      space: 1,
    ),
  );
}
