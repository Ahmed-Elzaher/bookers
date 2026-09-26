import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookers/core/theme/app_colors.dart';


abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      cardColor: AppColors.surface,
      dividerColor: AppColors.surfaceSubtle,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.available,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),
      useMaterial3: true,
    );
  }

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
