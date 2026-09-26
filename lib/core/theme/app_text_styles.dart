import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookers/core/theme/app_colors.dart';


abstract class AppTextStyles {
  static TextStyle get brandTitle => GoogleFonts.cairo(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get sectionTitle => GoogleFonts.cairo(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get dialogTitle => GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.45,
      );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.cairo(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get slotTime => GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get buttonLabel => GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );

  static TextStyle get badge => GoogleFonts.cairo(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      );

  static TextStyle get micro => GoogleFonts.cairo(
        fontSize: 9.sp,
        fontWeight: FontWeight.w800,
      );
}
