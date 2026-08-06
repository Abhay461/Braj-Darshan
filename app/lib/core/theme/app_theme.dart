import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Braj Darshan — System Theme & Color Tokens
class AppTheme {
  // Brand color tokens — Primary design language: Charcoal Black + White + Indigo
  static const Color primaryCharcoal = Color(0xFF18181B); // Charcoal Black
  static const Color secondaryIndigo = Color(0xFF5E5CE6); // Royal Indigo
  static const Color accentSkyBlue = Color(0xFF0EA5E9);   // Sky Blue
  
  // Devotional / Festival Accent (Reserved for badges & highlights, NOT primary/secondary)
  static const Color saffronHighlight = Color(0xFFFFB300); // Saffron

  static const Color canvasLight = Color(0xFFFAF9F6);     // Off-white canvas
  static const Color canvasDark = Color(0xFF09090B);      // Obsidian dark
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF141417);
  static const Color borderLight = Color(0xFFE5E7EB);     // Clean Gray Border
  static const Color borderDark = Color(0xFF27272A);
  static const Color mutedGrayLight = Color(0xFF64748B);  // WCAG AA compliant slate gray
  static const Color mutedGrayDark = Color(0xFFA1A1AA);   // Light slate gray for dark theme

  // System Design Tokens
  static const double borderRadius = 18.0;

  // Complete Typography Scale (Inter Font Family)
  static TextTheme appTextTheme(Color defaultTextColor) => TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: defaultTextColor,
        ),
      );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: canvasLight,
    colorScheme: const ColorScheme.light(
      primary: primaryCharcoal,
      onPrimary: Colors.white,
      secondary: secondaryIndigo,
      onSecondary: Colors.white,
      tertiary: accentSkyBlue,
      surface: cardLight,
      onSurface: primaryCharcoal,
      outline: borderLight,
      outlineVariant: borderLight,
    ),
    fontFamily: 'Inter',
    textTheme: appTextTheme(primaryCharcoal),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: borderLight, width: 1),
      ),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primaryCharcoal,
        fontFamily: 'Inter',
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      minVerticalPadding: 12,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      iconColor: primaryCharcoal,
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
      onSecondary: Colors.white,
      tertiary: accentSkyBlue,
      surface: cardDark,
      onSurface: Colors.white,
      outline: borderDark,
      outlineVariant: borderDark,
    ),
    fontFamily: 'Inter',
    textTheme: appTextTheme(Colors.white),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: borderDark, width: 1),
      ),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      minVerticalPadding: 12,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      iconColor: Colors.white,
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

