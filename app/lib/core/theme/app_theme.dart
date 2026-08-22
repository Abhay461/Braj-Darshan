import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Braj Darshan — Spiritual Design System
/// Primary: Saffron (#E65100) | Secondary: Saffron Light (#FF9800) | Gold Accent: #D4AF37
/// Background: Sandalwood Cream (#FFF9F0) | Text: Deep Brown (#2C1A0E)
class AppTheme {
  // ─── Spiritual Color Palette ──────────────────────────────────────
  
  // Light Theme Colors
  static const Color primarySaffron = Color(0xFFE65100);
  static const Color secondarySaffron = Color(0xFFFF9800);
  static const Color templeGold = Color(0xFFD4AF37);
  static const Color sandalwoodCream = Color(0xFFFFF9F0);
  static const Color deepBrown = Color(0xFF2C1A0E);
  static const Color creamWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE8D5B7);
  static const Color mutedBrown = Color(0xFF8B7355);
  
  // Dark Theme Colors
  static const Color primarySaffronDark = Color(0xFFFFB74D);
  static const Color secondarySaffronDark = Color(0xFFFF9800);
  static const Color templeGoldDark = Color(0xFFD4AF37);
  static const Color sandalwoodDark = Color(0xFF1A1508);
  static const Color deepBrownDark = Color(0xFFF5F5F5);
  static const Color cardDark = Color(0xFF231A0A);
  static const Color borderDark = Color(0xFF3D2E1A);
  static const Color mutedBrownDark = Color(0xFFA68B5B);

  // System Design Tokens
  static const double borderRadius = 18.0;
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusLarge = 24.0;

  // ─── Typography ───────────────────────────────────────────────────
  // Headings: Rozha One (with Noto Sans Devanagari fallback for Hindi)
  // Body: Outfit
  
  static TextTheme _buildTextTheme(Color defaultTextColor, bool isDark) {
    final headingFont = GoogleFonts.rozhaOne();
    final bodyFont = GoogleFonts.outfit();
    
    return TextTheme(
      // Headlines - Rozha One for spiritual/brand feel
      headlineLarge: headingFont.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: defaultTextColor,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      headlineMedium: headingFont.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: defaultTextColor,
        height: 1.25,
        letterSpacing: -0.3,
      ),
      headlineSmall: headingFont.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.3,
      ),
      
      // Titles - Rozha One for section headers
      titleLarge: headingFont.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.3,
      ),
      titleMedium: headingFont.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.35,
      ),
      titleSmall: headingFont.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.4,
      ),
      
      // Body - Outfit for readability
      bodyLarge: bodyFont.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: defaultTextColor,
        height: 1.5,
      ),
      bodyMedium: bodyFont.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: defaultTextColor,
        height: 1.5,
      ),
      bodySmall: bodyFont.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: defaultTextColor.withValues(alpha: 0.8),
        height: 1.4,
      ),
      
      // Labels - Outfit for UI elements
      labelLarge: bodyFont.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.4,
      ),
      labelMedium: bodyFont.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.4,
      ),
      labelSmall: bodyFont.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: defaultTextColor.withValues(alpha: 0.7),
        height: 1.3,
      ),
      
      // Display - for hero text
      displayLarge: headingFont.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: defaultTextColor,
        height: 1.1,
        letterSpacing: -1,
      ),
      displayMedium: headingFont.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: defaultTextColor,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      displaySmall: headingFont.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: defaultTextColor,
        height: 1.2,
      ),
    );
  }

  // ─── Light Theme ──────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const ColorScheme colorScheme = ColorScheme.light(
      primary: primarySaffron,
      onPrimary: Colors.white,
      secondary: secondarySaffron,
      onSecondary: Colors.white,
      tertiary: templeGold,
      surface: creamWhite,
      onSurface: deepBrown,
      outline: borderLight,
      outlineVariant: borderLight,
      surfaceContainerHighest: sandalwoodCream,
      surfaceContainerHigh: Color(0xFFF5ECDB),
      surfaceContainer: Color(0xFFF0E4CC),
      surfaceContainerLow: Color(0xFFFBF5E7),
      surfaceContainerLowest: creamWhite,
      inverseSurface: deepBrown,
      onInverseSurface: sandalwoodCream,
      shadow: Color(0x1A2C1A0E),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: sandalwoodCream,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(deepBrown, false),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: sandalwoodCream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: deepBrown, size: 24),
        titleTextStyle: GoogleFonts.rozhaOne(
          color: deepBrown,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        centerTitle: false,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: creamWhite,
        elevation: 0,
        shadowColor: const Color(0x1A2C1A0E),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: borderLight, width: 1),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: sandalwoodCream,
        disabledColor: borderLight.withValues(alpha: 0.5),
        selectedColor: primarySaffron.withValues(alpha: 0.15),
        secondarySelectedColor: secondarySaffron.withValues(alpha: 0.15),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: deepBrown,
        ),
        secondaryLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          side: const BorderSide(color: borderLight, width: 1),
        ),
        brightness: Brightness.light,
      ),
      
      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: Colors.transparent,
          foregroundColor: deepBrown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
        ),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        iconColor: deepBrown,
        textColor: deepBrown,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: deepBrown,
        ),
        subtitleTextStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: mutedBrown,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: creamWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: primarySaffron, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
        ),
        labelStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: mutedBrown,
        ),
        hintStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: mutedBrown.withValues(alpha: 0.6),
        ),
        errorStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFDC2626),
        ),
        floatingLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: primarySaffron,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySaffron,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: primarySaffron.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primarySaffron,
          side: const BorderSide(color: primarySaffron, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primarySaffron,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primarySaffron,
        foregroundColor: Colors.white,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 6,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: creamWhite,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: creamWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadiusLarge)),
        ),
        elevation: 8,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: creamWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        titleTextStyle: GoogleFonts.rozhaOne(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: deepBrown,
        ),
        contentTextStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: deepBrown,
          height: 1.5,
        ),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),
      
      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primarySaffron,
        linearTrackColor: borderLight,
        circularTrackColor: borderLight,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primarySaffron,
        inactiveTrackColor: borderLight,
        thumbColor: primarySaffron,
        overlayColor: primarySaffron.withValues(alpha: 0.15),
        valueIndicatorColor: primarySaffron,
        valueIndicatorTextStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: primarySaffron,
        unselectedLabelColor: mutedBrown,
        indicatorColor: primarySaffron,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ─── Dark Theme ───────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: primarySaffronDark,
      onPrimary: deepBrown,
      secondary: secondarySaffronDark,
      onSecondary: deepBrown,
      tertiary: templeGoldDark,
      surface: cardDark,
      onSurface: deepBrownDark,
      outline: borderDark,
      outlineVariant: borderDark,
      surfaceContainerHighest: Color(0xFF2D2315),
      surfaceContainerHigh: Color(0xFF362A18),
      surfaceContainer: Color(0xFF2D2315),
      surfaceContainerLow: Color(0xFF251D0F),
      surfaceContainerLowest: sandalwoodDark,
      inverseSurface: sandalwoodCream,
      onInverseSurface: deepBrown,
      shadow: Color(0x4D000000),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: sandalwoodDark,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(deepBrownDark, true),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: sandalwoodDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: deepBrownDark, size: 24),
        titleTextStyle: GoogleFonts.rozhaOne(
          color: deepBrownDark,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        centerTitle: false,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shadowColor: Colors.black54,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: borderDark, width: 1),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF2D2315),
        disabledColor: borderDark.withValues(alpha: 0.5),
        selectedColor: primarySaffronDark.withValues(alpha: 0.2),
        secondarySelectedColor: secondarySaffronDark.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: deepBrownDark,
        ),
        secondaryLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: deepBrown,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          side: const BorderSide(color: borderDark, width: 1),
        ),
        brightness: Brightness.dark,
      ),
      
      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: Colors.transparent,
          foregroundColor: deepBrownDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
        ),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        iconColor: deepBrownDark,
        textColor: deepBrownDark,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: deepBrownDark,
        ),
        subtitleTextStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: mutedBrownDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2D2315),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: borderDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: borderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: primarySaffronDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 2),
        ),
        labelStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: mutedBrownDark,
        ),
        hintStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: mutedBrownDark.withValues(alpha: 0.6),
        ),
        errorStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFF87171),
        ),
        floatingLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: primarySaffronDark,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySaffronDark,
          foregroundColor: deepBrown,
          elevation: 0,
          shadowColor: primarySaffronDark.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primarySaffronDark,
          side: const BorderSide(color: primarySaffronDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primarySaffronDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primarySaffronDark,
        foregroundColor: deepBrown,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 6,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardDark,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadiusLarge)),
        ),
        elevation: 8,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: cardDark,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        titleTextStyle: GoogleFonts.rozhaOne(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: deepBrownDark,
        ),
        contentTextStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: deepBrownDark,
          height: 1.5,
        ),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: borderDark,
        thickness: 1,
        space: 1,
      ),
      
      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primarySaffronDark,
        linearTrackColor: borderDark,
        circularTrackColor: borderDark,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primarySaffronDark,
        inactiveTrackColor: borderDark,
        thumbColor: primarySaffronDark,
        overlayColor: primarySaffronDark.withValues(alpha: 0.15),
        valueIndicatorColor: primarySaffronDark,
        valueIndicatorTextStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: deepBrown,
        ),
      ),
      
      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: primarySaffronDark,
        unselectedLabelColor: mutedBrownDark,
        indicatorColor: primarySaffronDark,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
