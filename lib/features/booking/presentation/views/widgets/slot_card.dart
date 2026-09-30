import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/core/utils/time_formatter.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';

class SlotCard extends StatefulWidget {
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
  State<SlotCard> createState() => _SlotCardState();
}

class _SlotCardState extends State<SlotCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.displayStatus == BookingStatus.selected;
    final bool isAvailable = widget.displayStatus == BookingStatus.available;

    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData statusIcon;
    String statusLabel;
    List<BoxShadow>? shadows;

    switch (widget.displayStatus) {
      case BookingStatus.selected:
        bgColor = AppColors.primary;
        borderColor = AppColors.primaryDark;
        textColor = AppColors.white;
        statusIcon = Icons.check_circle_rounded;
        statusLabel = AppTranslations.tr('selected', isArabic: widget.isArabic);
        shadows = [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ];
        break;
      case BookingStatus.booked:
        if (widget.isUserConfirmedBooking) {
          bgColor = AppColors.primary.withValues(alpha: 0.1);
          borderColor = AppColors.primary;
          textColor = AppColors.primary;
          statusIcon = Icons.bookmark_added_rounded;
          statusLabel = AppTranslations.tr('yourBooking', isArabic: widget.isArabic);
          shadows = [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ];
        } else {
          bgColor = AppColors.bookedBg;
          borderColor = AppColors.bookedBorder;
          textColor = AppColors.booked;
          statusIcon = Icons.lock_outline_rounded;
          statusLabel = AppTranslations.tr('booked', isArabic: widget.isArabic);
        }
        break;
      case BookingStatus.unavailable:
        bgColor = AppColors.unavailableBg;
        borderColor = AppColors.unavailableBorder.withValues(alpha: 0.6);
        textColor = AppColors.textMuted;
        statusIcon = Icons.coffee_rounded;
        statusLabel = AppTranslations.tr('unavailable', isArabic: widget.isArabic);
        break;
      case BookingStatus.available:
        if (widget.isEligibleStart) {
          bgColor = AppColors.surface;
          borderColor = AppColors.available;
          textColor = AppColors.textPrimary;
          statusIcon = Icons.check_circle_outline_rounded;
          statusLabel = AppTranslations.tr('available', isArabic: widget.isArabic);
          shadows = [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ];
        } else {
          bgColor = AppColors.background;
          borderColor = AppColors.surfaceSubtle;
          textColor = AppColors.textMuted;
          statusIcon = Icons.remove_circle_outline_rounded;
          statusLabel = AppTranslations.tr('notForDuration', isArabic: widget.isArabic);
        }
        break;
    }

    final startTime = TimeFormatter.formatMinutesTo12H(widget.slot.startMinutes, arabic: widget.isArabic);
    final endTime = TimeFormatter.formatMinutesTo12H(widget.slot.endMinutes, arabic: widget.isArabic);

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: AppConstants.animationFast,
      curve: Curves.easeOutCubic,
      child: InkWell(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        splashColor: isAvailable ? AppColors.primary.withValues(alpha: 0.15) : AppColors.transparent,
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: widget.isFocused
                  ? AppColors.primaryLight
                  : isSelected
                      ? AppColors.primaryDark
                      : borderColor,
              width: isSelected || widget.isFocused ? 2.0 : 1.0,
            ),
            boxShadow: widget.isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : shadows,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: widget.isArabic ? Alignment.topRight : Alignment.topLeft,
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
                          color: isSelected
                              ? AppColors.white.withValues(alpha: 0.25)
                              : AppColors.surfaceSubtle.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Text(
                          '#${(widget.slot.index + 1).toString().padLeft(2, '0')}',
                          style: AppTextStyles.micro.copyWith(
                            color: isSelected ? AppColors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isStartOfSelection)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                AppTranslations.tr('startSlotBadge', isArabic: widget.isArabic),
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if (widget.isPartOfSpan)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                AppTranslations.tr('connectedSlotBadge', isArabic: widget.isArabic),
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          Icon(
                            statusIcon,
                            size: 15.sp,
                            color: isSelected ? AppColors.white : borderColor,
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
                    '${widget.isArabic ? 'حتى' : 'to'} $endTime',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.white.withValues(alpha: 0.85) : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.white.withValues(alpha: 0.2)
                          : borderColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      statusLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: isSelected ? AppColors.white : borderColor,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
