import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';


class MyBookingsSheet extends StatelessWidget {
  const MyBookingsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: const MyBookingsSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final bool isAr = state.isArabic;
        final bookings = state.userBookings;

        return Directionality(
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 0.75.sh,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusModal)),
              border: const Border(top: BorderSide(color: AppColors.surfaceSubtle, width: 1.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.confirmation_num_rounded, color: AppColors.primary, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            AppTranslations.tr('myBookingsTitle', isArabic: isAr),
                            style: AppTextStyles.sectionTitle,
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Text(
                          '${bookings.length}',
                          style: AppTextStyles.badge.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.surfaceSubtle, height: 1),
                if (bookings.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_busy_rounded,
                          size: 48.sp,
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          AppTranslations.tr('noBookingsYet', isArabic: isAr),
                          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16.r),
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final ticket = bookings[index];

                        return Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            border: Border.all(
                              color: AppColors.surfaceSubtle,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x060F172A),
                                blurRadius: 6.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          ticket.id,
                                          style: AppTextStyles.micro.copyWith(color: AppColors.primary),
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        ticket.durationLabel,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.available.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle_rounded, size: 11.sp, color: AppColors.available),
                                        SizedBox(width: 3.w),
                                        Text(
                                          isAr ? 'مؤكد' : 'Confirmed',
                                          style: AppTextStyles.micro.copyWith(color: AppColors.available),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Icon(Icons.access_time_rounded, size: 15.sp, color: AppColors.textPrimary),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '${ticket.startTimeFormatted}  ➔  ${ticket.endTimeFormatted}',
                                    style: AppTextStyles.slotTime,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Align(
                                alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    cubit.cancelBooking(ticket.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppColors.surface,
                                        content: Text(
                                          AppTranslations.tr('cancelSuccess', isArabic: isAr),
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  ),
                                  icon: Icon(Icons.cancel_outlined, size: 14.sp),
                                  label: Text(
                                    AppTranslations.tr('cancelBooking', isArabic: isAr),
                                    style: AppTextStyles.badge.copyWith(color: AppColors.error),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
