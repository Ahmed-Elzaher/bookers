import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';


class SummaryDock extends StatelessWidget {
  const SummaryDock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final bool isAr = state.isArabic;
        final bool canConfirm = state.hasValidSelection;
        final String startTime = state.startTimeFormatted ?? '--:--';
        final String endTime = state.endTimeFormatted ?? '--:--';
        final String duration = state.durationLabel;

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusModal)),
            border: const Border(
              top: BorderSide(color: AppColors.surfaceSubtle, width: 1.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.06),
                blurRadius: 20.r,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumn(
                        label: AppTranslations.tr('startTime', isArabic: isAr),
                        value: startTime,
                        icon: Icons.login_rounded,
                        color: canConfirm ? AppColors.primary : AppColors.textMuted,
                      ),
                    ),
                    Container(
                      height: 28.h,
                      width: 1,
                      color: AppColors.surfaceSubtle,
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        label: AppTranslations.tr('endTime', isArabic: isAr),
                        value: endTime,
                        icon: Icons.logout_rounded,
                        color: canConfirm ? AppColors.primary : AppColors.textMuted,
                      ),
                    ),
                    Container(
                      height: 28.h,
                      width: 1,
                      color: AppColors.surfaceSubtle,
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        label: AppTranslations.tr('totalDuration', isArabic: isAr),
                        value: duration,
                        icon: Icons.timer_outlined,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    IconButton.outlined(
                      onPressed: () => _showResetDialog(context, cubit, isAr),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        backgroundColor: AppColors.background,
                        side: const BorderSide(color: AppColors.surfaceSubtle),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                        minimumSize: Size(44.w, 44.h),
                      ),
                      tooltip: AppTranslations.tr('resetSchedule', isArabic: isAr),
                      icon: Icon(Icons.refresh_rounded, size: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AnimatedScale(
                        scale: canConfirm ? 1.0 : 0.98,
                        duration: AppConstants.animationFast,
                        curve: Curves.easeOutCubic,
                        child: ElevatedButton.icon(
                          onPressed: canConfirm ? () => _handleConfirm(cubit) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.unavailableBg,
                            disabledForegroundColor: AppColors.textMuted,
                            elevation: canConfirm ? 3 : 0,
                            shadowColor: AppColors.primary.withValues(alpha: 0.35),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            ),
                          ),
                          icon: Icon(Icons.check_circle_outline_rounded, size: 18.sp),
                          label: Text(
                            canConfirm
                                ? AppTranslations.tr('confirmBooking', isArabic: isAr)
                                : AppTranslations.tr('selectValidSlot', isArabic: isAr),
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: canConfirm ? AppColors.white : AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoColumn({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12.sp, color: AppColors.textMuted),
            SizedBox(width: 3.w),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: AppTextStyles.slotTime.copyWith(color: color),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _handleConfirm(
    BookingCubit cubit,
  ) {
    cubit.confirmBooking();
  }

  void _showResetDialog(BuildContext context, BookingCubit cubit, bool isAr) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            side: const BorderSide(color: AppColors.surfaceSubtle),
          ),
          title: Row(
            children: [
              Icon(Icons.refresh_rounded, color: AppColors.warning, size: 22.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppTranslations.tr('resetConfirmTitle', isArabic: isAr),
                  style: AppTextStyles.dialogTitle,
                ),
              ),
            ],
          ),
          content: Text(
            AppTranslations.tr('resetConfirmMessage', isArabic: isAr),
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                AppTranslations.tr('cancel', isArabic: isAr),
                style: AppTextStyles.bodySmall,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                cubit.resetSchedule();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surface,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      side: const BorderSide(color: AppColors.surfaceSubtle),
                    ),
                    content: Text(
                      AppTranslations.tr('resetSuccess', isArabic: isAr),
                      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
              ),
              child: Text(
                AppTranslations.tr('confirmReset', isArabic: isAr),
                style: AppTextStyles.badge.copyWith(color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
