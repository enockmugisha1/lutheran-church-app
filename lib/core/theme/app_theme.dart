import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Brand colours (3-colour palette) ─────────────────────────────────────
  /// Warm Gold — primary accent across the whole app
  static const Color gold = Color(0xFFC9A84C);

  /// Deep Maroon — used for AppBar, headers, dark fills
  static const Color maroon = Color(0xFF4A1028);

  /// Warm off-white surface
  static const Color warmWhite = Color(0xFFFAF7F2);

  // ---------------------------------------------------------------------------
  // LIGHT THEME
  // ---------------------------------------------------------------------------
  static ThemeData lightTheme({Color? seasonColor}) {
    const primaryColor = maroon;
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: gold,
      onSecondary: Colors.white,
      error: const Color(0xFFB00020),
      onError: Colors.white,
      surface: warmWhite,
      onSurface: const Color(0xFF1A1A1A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: warmWhite,
      textTheme: _buildTextTheme(base: ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.4,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        shadowColor: Colors.black26,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
        hintStyle: GoogleFonts.lato(color: Colors.grey.shade400, fontSize: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEBE7),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: gold.withValues(alpha: 0.1),
        selectedColor: gold.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.lato(
          color: maroon,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: maroon,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: GoogleFonts.lato(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.lato(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DARK THEME
  // ---------------------------------------------------------------------------
  static ThemeData darkTheme({Color? seasonColor}) {
    const surfaceColor = Color(0xFF14101A);
    const cardColor = Color(0xFF1E1924);

    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: gold,
      onPrimary: Colors.black,
      secondary: gold,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: Colors.black,
      surface: surfaceColor,
      onSurface: const Color(0xFFF5F2EC),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0E0B14),
      textTheme: _buildTextTheme(base: ThemeData.dark().textTheme, dark: true),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: const Color(0xFF1A1520),
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.4,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3A3847)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3A3847)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
        hintStyle: GoogleFonts.lato(
          color: const Color(0xFF9896AE),
          fontSize: 14,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2E2C3B),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: gold.withValues(alpha: 0.12),
        selectedColor: gold.withValues(alpha: 0.25),
        labelStyle: GoogleFonts.lato(
          color: gold,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1A1520),
        selectedItemColor: gold,
        unselectedItemColor: const Color(0xFF9896AE),
        selectedLabelStyle: GoogleFonts.lato(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.lato(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TEXT THEMES
  // ---------------------------------------------------------------------------
  static TextTheme _buildTextTheme({
    required TextTheme base,
    bool dark = false,
  }) {
    final baseColor = dark ? const Color(0xFFF5F2EC) : const Color(0xFF1A1A1A);
    final subtleColor = dark
        ? const Color(0xFFB8B6CC)
        : const Color(0xFF5A5760);

    return base.copyWith(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: baseColor,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineLarge: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineSmall: GoogleFonts.cinzel(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.55,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: subtleColor,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: subtleColor,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: subtleColor,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // READING STYLES
  // ---------------------------------------------------------------------------
  static TextStyle bibleTextStyle({double fontSize = 18, bool dark = false}) {
    return GoogleFonts.notoSerif(
      fontSize: fontSize,
      height: 1.8,
      letterSpacing: 0.3,
      color: dark ? const Color(0xFFF0EDE8) : const Color(0xFF1A1A1A),
    );
  }

  static TextStyle liturgyTextStyle({
    double fontSize = 15,
    bool isCongregation = false,
    bool dark = false,
  }) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: isCongregation ? FontWeight.w600 : FontWeight.w400,
      height: 1.65,
      color: dark ? const Color(0xFFF0EDE8) : const Color(0xFF1A1A1A),
    );
  }

  static TextStyle hymnTextStyle({double fontSize = 16, bool dark = false}) {
    return GoogleFonts.notoSerif(
      fontSize: fontSize,
      height: 2.0,
      fontStyle: FontStyle.italic,
      color: dark ? const Color(0xFFF0EDE8) : const Color(0xFF2A2A2A),
    );
  }

  // ---------------------------------------------------------------------------
  // GRADIENT HELPERS
  // ---------------------------------------------------------------------------
  static LinearGradient seasonGradient(Color seasonColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [seasonColor, Color.lerp(seasonColor, Colors.black, 0.3)!],
    );
  }

  static LinearGradient cardAccentGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.05)],
    );
  }

  /// Gold shimmer gradient for premium accents
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8C76A), Color(0xFFC9A84C), Color(0xFFA6853C)],
  );

  /// Maroon gradient for headers / hero areas
  static const LinearGradient maroonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6B1A38), Color(0xFF4A1028), Color(0xFF2C0818)],
  );

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
  static Color liturgicalColorToColor(String? c, {bool useTint = false}) {
    Color base;
    switch (c) {
      case 'white':
        base = const Color(0xFFF5F0DC);
      case 'green':
        base = const Color(0xFF2E7D32);
      case 'purple':
        base = const Color(0xFF6A0DAD);
      case 'red':
        base = const Color(0xFFD32F2F);
      case 'black':
        base = const Color(0xFF37474F);
      default:
        base = const Color(0xFF2E7D32);
    }
    return useTint ? base.withValues(alpha: 0.12) : base;
  }
}
