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


class DiagnosticDialog extends StatelessWidget {
  const DiagnosticDialog({
    super.key,
    required this.failure,
  });

  final Failure failure;

  static void show(BuildContext context, Failure failure) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: DiagnosticDialog(failure: failure),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<BookingCubit>().dismissDiagnosticModal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final bool isAr = state.isArabic;
        final alternatives = state.allAvailableAlternatives;

        Color accentColor;
        IconData iconData;
        String title;
        String description;

        if (failure is IsolatedGapFailure) {
          accentColor = AppColors.warning;
          iconData = Icons.schedule_rounded;
          title = isAr ? 'الموعد غير متوافق مع الجدول' : 'Slot Incompatible With Schedule';
          description = isAr
              ? 'عفواً، لا يمكن بدء موعد بهذا التوقيت لضمان تنظيم جدول المواعيد. يُرجى اختيار أحد المواعيد البديلة المقترحة بالأسفل.'
              : 'This time slot cannot be booked to preserve schedule organization. Please choose one of the recommended alternative slots below.';
        } else if (failure is OverlapFailure) {
          accentColor = AppColors.error;
          iconData = Icons.event_busy_rounded;
          title = isAr ? 'تعارض مع موعد آخر' : 'Schedule Conflict';
          description = isAr
              ? 'يتعارض هذا التوقيت مع موعد محجوز مسبقاً أو فترة استراحة. يمكنك اختيار أحد المواعيد المتاحة.'
              : 'The selected slot conflicts with an existing booking or break. Please select from the available alternatives.';
        } else if (failure is OutOfBoundsFailure) {
          accentColor = AppColors.error;
          iconData = Icons.av_timer_rounded;
          title = isAr ? 'تجاوز موعد الإغلاق' : 'Past Closing Time';
          description = isAr
              ? 'مدة الحجز المختارة تتجاوز موعد نهاية يوم العمل (الساعة 6:00 مساءً). نقترح عليك البدء في توقيت أبكر.'
              : 'The selected duration extends past the 6:00 PM closing time. We recommend choosing an earlier start time.';
        } else {
          accentColor = AppColors.textMuted;
          iconData = Icons.info_outline_rounded;
          title = isAr ? 'الموعد غير متاح' : 'Slot Unavailable';
          description = isAr ? 'هذا الموعد محجوز أو غير متاح حالياً.' : failure.message;
        }

        return Directionality(
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          child: Dialog(
            backgroundColor: AppColors.surface,
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusModal),
              side: BorderSide(color: accentColor.withValues(alpha: 0.5), width: 1.5),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 0.85.sh),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(18.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                          ),
                          child: Icon(iconData, color: accentColor, size: 24.sp),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.dialogTitle.copyWith(color: accentColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      description,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // عرض جميع البدائل المتاحة في اليوم لهذه المدة
                    if (alternatives.isNotEmpty) ...[
                      Text(
                        AppTranslations.tr('allAvailableAlternatives', isArabic: isAr),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 160.h),
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            children: alternatives.map((slotIndex) {
                              final slotRange = TimeFormatter.formatSlotRange(
                                slotIndex,
                                slotSpan: state.selectedDuration.slotCount,
                                arabic: isAr,
                              );

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  cubit.selectAlternativeAndFocus(slotIndex);
                                },
                                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time_filled_rounded,
                                        size: 13.sp,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        slotRange,
                                        style: AppTextStyles.slotTime.copyWith(
                                          fontSize: 11.sp,
                                          color: AppColors.primaryDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16.sp, color: AppColors.textMuted),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                AppTranslations.tr('noAlternativesFound', isArabic: isAr),
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                    ],

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textMuted,
                        ),
                        child: Text(
                          AppTranslations.tr('chooseAnotherSlot', isArabic: isAr),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
