import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/errors/failures.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/core/utils/time_formatter.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';

//! =========================================================
//! Widget: FeedbackCard
//! =========================================================

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) =>
          previous.failure != current.failure ||
          previous.suggestedAlternativeIndex != current.suggestedAlternativeIndex ||
          previous.isArabic != current.isArabic,
      builder: (context, state) {
        final failure = state.failure;
        if (failure == null) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<BookingCubit>();
        final int? altIndex = state.suggestedAlternativeIndex;
        final bool isAr = state.isArabic;

        Color cardBg;
        Color borderColor;
        IconData iconData;
        String title;

        if (failure is IsolatedGapFailure) {
          cardBg = AppColors.warningBg.withValues(alpha: 0.6);
          borderColor = AppColors.warning;
          iconData = Icons.warning_amber_rounded;
          title = AppTranslations.tr('isolatedGapTitle', isArabic: isAr);
        } else if (failure is OverlapFailure) {
          cardBg = AppColors.errorBg.withValues(alpha: 0.6);
          borderColor = AppColors.error;
          iconData = Icons.error_outline_rounded;
          title = AppTranslations.tr('conflictTitle', isArabic: isAr);
        } else if (failure is OutOfBoundsFailure) {
          cardBg = AppColors.errorBg.withValues(alpha: 0.6);
          borderColor = AppColors.error;
          iconData = Icons.av_timer_rounded;
          title = AppTranslations.tr('outOfBoundsTitle', isArabic: isAr);
        } else {
          cardBg = AppColors.surfaceSubtle.withValues(alpha: 0.6);
          borderColor = AppColors.textMuted;
          iconData = Icons.info_outline_rounded;
          title = AppTranslations.tr('invalidStartTitle', isArabic: isAr);
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: borderColor.withValues(alpha: 0.15),
                blurRadius: 10.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(iconData, color: borderColor, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.dialogTitle.copyWith(color: borderColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                failure.message,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              if (altIndex != null) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        color: AppColors.primaryLight,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.tr('suggestedAlternative', isArabic: isAr),
                              style: AppTextStyles.bodySmall,
                            ),
                            Text(
                              '${AppTranslations.tr('startsAt', isArabic: isAr)} ${TimeFormatter.formatMinutesTo12H(state.slots[altIndex].startMinutes, arabic: isAr)}',
                              style: AppTextStyles.slotTime.copyWith(color: AppColors.primaryLight),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => cubit.applySuggestedAlternative(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                          ),
                        ),
                        child: Text(
                          AppTranslations.tr('applyAlternative', isArabic: isAr),
                          style: AppTextStyles.badge.copyWith(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
