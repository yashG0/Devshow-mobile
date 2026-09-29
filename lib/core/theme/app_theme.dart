import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF0B0D10);
  static const surface = Color(0xFF111318);
  static const surfaceElevated = Color(0xFF171A21);
  static const border = Color(0xFF262A33);

  static const primary = Color(0xFF8B8CFF);
  static const text = Color(0xFFF4F4F5);
  static const secondaryText = Color(0xFFA1A1AA);
  static const mutedText = Color(0xFF71717A);
  static const success = Color(0xFF3DDC97);
  static const danger = Color(0xFFFF6B6B);

  static ThemeData get dark {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primary,
          surface: background,
          onSurface: text,
          outline: border,
        );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary),
        ),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorSchemeSeed: primary,
      fontFamily: 'Inter',
    );
  }
}
