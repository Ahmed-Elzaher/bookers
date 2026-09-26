import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';

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
                color: AppColors.primary,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${selectedDuration.slotCount} ${AppTranslations.tr('slotsCount', isArabic: isArabic)} (${selectedDuration.totalMinutes} ${AppTranslations.tr('minutes', isArabic: isArabic)})',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
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

              return _DurationPill(
                isSelected: isSelected,
                label: durationLabel,
                onTap: () => onDurationChanged(duration),
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

class _DurationPill extends StatefulWidget {
  const _DurationPill({
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  State<_DurationPill> createState() => _DurationPillState();
}

class _DurationPillState extends State<_DurationPill> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      child: InkWell(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 9.h,
          ),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  )
                : null,
            color: widget.isSelected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: widget.isSelected ? AppColors.primaryDark : AppColors.surfaceSubtle,
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 8.r,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0x080F172A),
                      blurRadius: 4.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 15.sp,
                color: widget.isSelected ? AppColors.white : AppColors.textMuted,
              ),
              SizedBox(width: 6.w),
              Text(
                widget.label,
                style: AppTextStyles.body.copyWith(
                  fontSize: 12.sp,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: widget.isSelected ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
