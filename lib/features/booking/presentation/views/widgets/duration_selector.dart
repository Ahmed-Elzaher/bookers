import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';

//! =========================================================
//! Widget: DurationSelector
//! =========================================================

class DurationSelector extends StatelessWidget {
  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.isArabic,
    required this.onDurationChanged,
  });

  final BookingDuration selectedDuration;
  final bool isArabic;
  final ValueChanged<BookingDuration> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.timelapse_rounded,
                color: AppColors.primaryLight,
                size: 17.sp,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  AppTranslations.tr('selectDuration', isArabic: isArabic),
                  style: AppTextStyles.sectionTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${selectedDuration.slotCount} ${AppTranslations.tr('slotsCount', isArabic: isArabic)} (${selectedDuration.totalMinutes} ${AppTranslations.tr('minutes', isArabic: isArabic)})',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: BookingDuration.values.map((duration) {
              final bool isSelected = duration == selectedDuration;
              final String durationLabel = _getLocalizedDurationLabel(duration);

              return InkWell(
                onTap: () => onDurationChanged(duration),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                child: AnimatedContainer(
                  duration: AppConstants.animationFast,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark,
                            ],
                          )
                        : null,
                    color: isSelected ? null : AppColors.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryLight : AppColors.surfaceSubtle,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8.r,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        size: 15.sp,
                        color: isSelected ? AppColors.white : AppColors.textMuted,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        durationLabel,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getLocalizedDurationLabel(BookingDuration duration) {
    switch (duration) {
      case BookingDuration.thirtyMin:
        return AppTranslations.tr('duration30m', isArabic: isArabic);
      case BookingDuration.oneHour:
        return AppTranslations.tr('duration1h', isArabic: isArabic);
      case BookingDuration.oneAndHalfHour:
        return AppTranslations.tr('duration1_5h', isArabic: isArabic);
      case BookingDuration.twoHours:
        return AppTranslations.tr('duration2h', isArabic: isArabic);
    }
  }
}
