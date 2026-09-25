import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/core/utils/time_formatter.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';

//! =========================================================
//! Widget: SlotCard
//! =========================================================

class SlotCard extends StatelessWidget {
  const SlotCard({
    super.key,
    required this.slot,
    required this.displayStatus,
    required this.isEligibleStart,
    required this.isStartOfSelection,
    required this.isPartOfSpan,
    required this.isUserConfirmedBooking,
    required this.isFocused,
    required this.isArabic,
    required this.onTap,
  });

  final SlotEntity slot;
  final BookingStatus displayStatus;
  final bool isEligibleStart;
  final bool isStartOfSelection;
  final bool isPartOfSpan;
  final bool isUserConfirmedBooking;
  final bool isFocused;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = displayStatus == BookingStatus.selected;
    final bool isAvailable = displayStatus == BookingStatus.available;

    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData statusIcon;
    String statusLabel;

    switch (displayStatus) {
      case BookingStatus.selected:
        bgColor = AppColors.primary.withValues(alpha: 0.25);
        borderColor = AppColors.primaryLight;
        textColor = AppColors.textPrimary;
        statusIcon = Icons.check_circle_rounded;
        statusLabel = AppTranslations.tr('selected', isArabic: isArabic);
        break;
      case BookingStatus.booked:
        if (isUserConfirmedBooking) {
          bgColor = AppColors.primary.withValues(alpha: 0.2);
          borderColor = AppColors.primaryLight;
          textColor = AppColors.primaryLight;
          statusIcon = Icons.bookmark_added_rounded;
          statusLabel = AppTranslations.tr('yourBooking', isArabic: isArabic);
        } else {
          bgColor = AppColors.bookedBg.withValues(alpha: 0.45);
          borderColor = AppColors.bookedBorder.withValues(alpha: 0.4);
          textColor = AppColors.bookedLight;
          statusIcon = Icons.lock_outline_rounded;
          statusLabel = AppTranslations.tr('booked', isArabic: isArabic);
        }
        break;
      case BookingStatus.unavailable:
        bgColor = AppColors.unavailableBg;
        borderColor = AppColors.unavailableBorder.withValues(alpha: 0.3);
        textColor = AppColors.textMuted;
        statusIcon = Icons.coffee_rounded;
        statusLabel = AppTranslations.tr('unavailable', isArabic: isArabic);
        break;
      case BookingStatus.available:
        bgColor = AppColors.surface;
        borderColor = isEligibleStart ? AppColors.available.withValues(alpha: 0.5) : AppColors.surfaceSubtle;
        textColor = AppColors.textPrimary;
        statusIcon = Icons.access_time_rounded;
        statusLabel = AppTranslations.tr('available', isArabic: isArabic);
        break;
    }

    final startTime = TimeFormatter.formatMinutesTo12H(slot.startMinutes, arabic: isArabic);
    final endTime = TimeFormatter.formatMinutesTo12H(slot.endMinutes, arabic: isArabic);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      splashColor: isAvailable ? AppColors.primary.withValues(alpha: 0.2) : AppColors.transparent,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isFocused
                ? AppColors.primaryLight
                : isSelected
                    ? AppColors.primaryLight
                    : borderColor,
            width: isSelected || isFocused ? 2.0 : 1.0,
          ),
          boxShadow: isSelected || isFocused
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10.r,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: isArabic ? Alignment.topRight : Alignment.topLeft,
          child: SizedBox(
            width: 155.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Text(
                    '#${(slot.index + 1).toString().padLeft(2, '0')}',
                    style: AppTextStyles.micro.copyWith(
                      color: isSelected ? AppColors.primaryLight : AppColors.textMuted,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isStartOfSelection)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          AppTranslations.tr('startSlotBadge', isArabic: isArabic),
                          style: AppTextStyles.micro.copyWith(color: AppColors.white),
                        ),
                      )
                    else if (isPartOfSpan)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          AppTranslations.tr('connectedSlotBadge', isArabic: isArabic),
                          style: AppTextStyles.micro.copyWith(color: AppColors.white),
                        ),
                      ),
                    Icon(
                      statusIcon,
                      size: 15.sp,
                      color: borderColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              startTime,
              style: AppTextStyles.slotTime.copyWith(
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${isArabic ? 'حتى' : 'to'} $endTime',
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: borderColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                statusLabel,
                style: AppTextStyles.micro.copyWith(color: borderColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}
