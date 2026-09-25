import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';
import 'package:bookers/features/booking/presentation/views/widgets/feature_tour_dialog.dart';
import 'package:bookers/features/booking/presentation/views/widgets/my_bookings_sheet.dart';

//! =========================================================
//! Widget: BookingHeader
//! =========================================================

class BookingHeader extends StatelessWidget {
  const BookingHeader({
    super.key,
    required this.onResetPressed,
  });

  final VoidCallback onResetPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) =>
          prev.isArabic != curr.isArabic || prev.userBookings.length != curr.userBookings.length,
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final bool isAr = state.isArabic;
        final int bookingCount = state.userBookings.length;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.85),
            border: const Border(
              bottom: BorderSide(color: AppColors.surfaceSubtle, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.schedule_rounded,
                      color: AppColors.primaryLight,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.tr('appName', isArabic: isAr),
                          style: AppTextStyles.brandTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          AppTranslations.tr('appSubtitle', isArabic: isAr),
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر تبديل اللغة
                      InkWell(
                        onTap: () => cubit.toggleLanguage(),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                          ),
                          child: Text(
                            AppTranslations.tr('changeLanguage', isArabic: isAr),
                            style: AppTextStyles.badge.copyWith(color: AppColors.primaryLight),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),

                      // زر جولة الدليل
                      IconButton(
                        onPressed: () => FeatureTourDialog.show(context, isAr),
                        tooltip: AppTranslations.tr('quickGuide', isArabic: isAr),
                        icon: Icon(Icons.help_outline_rounded, size: 19.sp, color: AppColors.textSecondary),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                      ),

                      // زر حجوزاتي مع Badge
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => MyBookingsSheet.show(context),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surfaceSubtle.withValues(alpha: 0.5),
                              foregroundColor: AppColors.textPrimary,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(32.w, 32.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                              ),
                            ),
                            tooltip: AppTranslations.tr('myBookings', isArabic: isAr),
                            icon: Icon(Icons.confirmation_num_outlined, size: 18.sp),
                          ),
                          if (bookingCount > 0)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(3.r),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(minWidth: 14.r, minHeight: 14.r),
                                child: Text(
                                  '$bookingCount',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.micro.copyWith(color: AppColors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 4.w),

                      // زر Reset
                      IconButton.filledTonal(
                        onPressed: onResetPressed,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceSubtle.withValues(alpha: 0.5),
                          foregroundColor: AppColors.textPrimary,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(32.w, 32.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                          ),
                        ),
                        tooltip: AppTranslations.tr('resetSchedule', isArabic: isAr),
                        icon: Icon(Icons.refresh_rounded, size: 18.sp),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // دليل الحالات (Status Legend)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildLegendItem(
                      color: AppColors.available,
                      label: AppTranslations.tr('available', isArabic: isAr),
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    SizedBox(width: 8.w),
                    _buildLegendItem(
                      color: AppColors.selected,
                      label: AppTranslations.tr('selected', isArabic: isAr),
                      icon: Icons.radio_button_checked_rounded,
                    ),
                    SizedBox(width: 8.w),
                    _buildLegendItem(
                      color: AppColors.booked,
                      label: AppTranslations.tr('booked', isArabic: isAr),
                      icon: Icons.lock_outline_rounded,
                    ),
                    SizedBox(width: 8.w),
                    _buildLegendItem(
                      color: AppColors.unavailable,
                      label: AppTranslations.tr('unavailable', isArabic: isAr),
                      icon: Icons.coffee_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13.sp),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppTextStyles.badge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
