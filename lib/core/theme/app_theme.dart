import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookers/core/theme/app_colors.dart';

//! =========================================================
//! Application Theme Configuration
//! =========================================================

abstract class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.available,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
    );
  }
}
