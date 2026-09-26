import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';
import 'package:bookers/features/booking/presentation/views/widgets/slot_card.dart';

import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/features/booking/presentation/views/widgets/my_bookings_sheet.dart';


class SlotsGrid extends StatelessWidget {
  const SlotsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) =>
          previous.slots != current.slots ||
          previous.selectedIndices != current.selectedIndices ||
          previous.validStartIndices != current.validStartIndices ||
          previous.selectedStartIndex != current.selectedStartIndex ||
          previous.userBookings != current.userBookings ||
          previous.focusedSlotIndex != current.focusedSlotIndex ||
          previous.isArabic != current.isArabic,
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        // جمع الخانات التي حجزها المستخدم نفسه
        final userBookedSlotIndices = <int>{};
        for (final booking in state.userBookings) {
          userBookedSlotIndices.addAll(booking.slotIndices);
        }

        final isAr = state.isArabic;

        final periods = [
          _TimePeriod(
            title: isAr ? 'الفترة الصباحية' : 'Morning Period',
            timeRange: isAr ? '9:00 ص - 12:00 م' : '9:00 AM - 12:00 PM',
            icon: Icons.wb_twilight_rounded,
            indices: List.generate(6, (i) => i),
          ),
          _TimePeriod(
            title: isAr ? 'فترة الظهيرة' : 'Afternoon Period',
            timeRange: isAr ? '12:00 م - 3:00 م' : '12:00 PM - 3:00 PM',
            icon: Icons.wb_sunny_rounded,
            indices: List.generate(6, (i) => i + 6),
          ),
          _TimePeriod(
            title: isAr ? 'فترة المساء' : 'Evening Period',
            timeRange: isAr ? '3:00 م - 6:00 م' : '3:00 PM - 6:00 PM',
            icon: Icons.nightlight_round,
            indices: List.generate(6, (i) => i + 12),
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth > 700) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 480) {
              crossAxisCount = 3;
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: periods.map((period) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
                        child: Row(
                          children: [
                            Icon(
                              period.icon,
                              size: 16.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                period.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSubtle.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                period.timeRange,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.15,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                        ),
                        itemCount: period.indices.length,
                        itemBuilder: (context, i) {
                          final index = period.indices[i];
                          if (index >= state.slots.length) return const SizedBox.shrink();

                          final slot = state.slots[index];
                          final displayStatus = state.getDisplayStatus(index);
                          final isEligibleStart = state.validStartIndices.contains(index);
                          final isStartOfSelection = state.selectedStartIndex == index;
                          final isPartOfSpan = state.selectedIndices.contains(index) && !isStartOfSelection;
                          final isUserConfirmed = userBookedSlotIndices.contains(index);
                          final isFocused = state.focusedSlotIndex == index;

                          return SlotCard(
                            key: ValueKey('slot_${slot.index}'),
                            slot: slot,
                            displayStatus: displayStatus,
                            isEligibleStart: isEligibleStart,
                            isStartOfSelection: isStartOfSelection,
                            isPartOfSpan: isPartOfSpan,
                            isUserConfirmedBooking: isUserConfirmed,
                            isFocused: isFocused,
                            isArabic: state.isArabic,
                            onTap: () {
                              if (isUserConfirmed) {
                                MyBookingsSheet.show(context);
                              } else {
                                cubit.selectSlot(index);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class _TimePeriod {
  const _TimePeriod({
    required this.title,
    required this.timeRange,
    required this.icon,
    required this.indices,
  });

  final String title;
  final String timeRange;
  final IconData icon;
  final List<int> indices;
}
