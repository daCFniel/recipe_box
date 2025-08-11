import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeBoxTheme {
  static const bool _shouldUseMaterial3 = true;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: _shouldUseMaterial3,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFB39DDB),
        brightness: Brightness.dark,
      ),
      textTheme: _darkTextTheme,
    );
  }

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.roboto(
      fontSize: 57.0,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.roboto(
      fontSize: 45.0,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.roboto(
      fontSize: 36.0,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: GoogleFonts.roboto(
      fontSize: 32.0,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 28.0,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: GoogleFonts.roboto(
      fontSize: 24.0,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.roboto(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.roboto(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.roboto(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.roboto(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    ),
  );
}