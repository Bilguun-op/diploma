import 'package:flutter/material.dart';

class AppTheme {
  static const Color _background = Color(0xFF1A1A2E);
  static const Color _foreground = Color(0xFFF8F8F8);
  static const Color _card = Color(0xFF252542);
  static const Color _cardForeground = Color(0xFFF8F8F8);
  static const Color _popover = Color(0xFF252542);
  static const Color _popoverForeground = Color(0xFFF8F8F8);
  static const Color _primary = Color(0xFF9F7AEA);
  static const Color _primaryForeground = Color(0xFFF8F8F8);
  static const Color _secondary = Color(0xFF4A4A6A);
  static const Color _secondaryForeground = Color(0xFFF8F8F8);
  static const Color _muted = Color(0xFF3A3A5A);
  static const Color _mutedForeground = Color(0xFFB8B8D0);
  static const Color _accent = Color(0xFF38BDF8);
  static const Color _accentForeground = Color(0xFF1A1A2E);
  static const Color _destructive = Color(0xFFEF4444);
  static const Color _destructiveForeground = Color(0xFFF8F8F8);
  static const Color _border = Color(0xFF4A4A6A);
  static const Color _input = Color(0xFF3A3A5A);
  static const Color _ring = Color(0xFF9F7AEA);
  static const Color _amber = Color(0xFFF59E0B);
  static const Color _amberForeground = Color(0xFF1A1A2E);
  static const Color _emerald = Color(0xFF10B981);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: _background,
        onBackground: _foreground,
        primary: _primary,
        onPrimary: _primaryForeground,
        secondary: _secondary,
        onSecondary: _secondaryForeground,
        surface: _card,
        onSurface: _cardForeground,
        error: _destructive,
        onError: _destructiveForeground,
      ),
      scaffoldBackgroundColor: _background,
      cardColor: _card,
      dividerColor: _border,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _foreground, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: _foreground, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: _foreground, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: _foreground, fontSize: 22, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: _foreground, fontSize: 20, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: _foreground, fontSize: 18, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: _foreground, fontSize: 16, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: _foreground, fontSize: 14, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: _foreground, fontSize: 12, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: _foreground, fontSize: 16),
        bodyMedium: TextStyle(color: _foreground, fontSize: 14),
        bodySmall: TextStyle(color: _mutedForeground, fontSize: 12),
        labelLarge: TextStyle(color: _foreground, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: _foreground, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: _mutedForeground, fontSize: 11, fontWeight: FontWeight.w500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _primaryForeground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _foreground,
          side: BorderSide(color: _border),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _foreground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardTheme(
        color: _card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _border.withOpacity(0.6)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF0D0D1A),
        onBackground: Color(0xFFF8F8F8),
        primary: Color(0xFFE8E8FF),
        onPrimary: Color(0xFF0D0D1A),
        secondary: Color(0xFF3A3A5A),
        onSecondary: Color(0xFFF8F8F8),
        surface: Color(0xFF1A1A2E),
        onSurface: Color(0xFFF8F8F8),
        error: Color(0xFFEF4444),
        onError: Color(0xFFF8F8F8),
      ),
      scaffoldBackgroundColor: const Color(0xFF0D0D1A),
      cardColor: const Color(0xFF1A1A2E),
      dividerColor: const Color(0xFF3A3A5A),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFF8F8F8), fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Color(0xFFF8F8F8), fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Color(0xFFF8F8F8), fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Color(0xFFF8F8F8), fontSize: 22, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Color(0xFFF8F8F8), fontSize: 20, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: Color(0xFFF8F8F8), fontSize: 18, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Color(0xFFF8F8F8), fontSize: 16, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFF8F8F8), fontSize: 14, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: Color(0xFFF8F8F8), fontSize: 12, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Color(0xFFF8F8F8), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFFF8F8F8), fontSize: 14),
        bodySmall: TextStyle(color: Color(0xFFB8B8D0), fontSize: 12),
        labelLarge: TextStyle(color: Color(0xFFF8F8F8), fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: Color(0xFFF8F8F8), fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: Color(0xFFB8B8D0), fontSize: 11, fontWeight: FontWeight.w500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9F7AEA),
          foregroundColor: const Color(0xFFF8F8F8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF8F8F8),
          side: const BorderSide(color: Color(0xFF3A3A5A)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFF8F8F8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A4A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3A3A5A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3A3A5A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9F7AEA)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1A1A2E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF3A3A5A), width: 0.6),
        ),
      ),
    );
  }

  static BoxDecoration get heroGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF9F7AEA), Color(0xFF38BDF8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  static BoxDecoration get amberGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  static List<BoxShadow> get glowShadow {
    return [
      BoxShadow(
        color: _primary.withOpacity(0.55),
        blurRadius: 40,
        spreadRadius: -8,
      ),
    ];
  }

  static List<BoxShadow> get cyanShadow {
    return [
      BoxShadow(
        color: _accent.withOpacity(0.5),
        blurRadius: 30,
        spreadRadius: -6,
      ),
    ];
  }
}
