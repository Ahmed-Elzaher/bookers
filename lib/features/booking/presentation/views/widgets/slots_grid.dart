import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';
import 'package:bookers/features/booking/presentation/views/widgets/slot_card.dart';

//! =========================================================
//! Widget: SlotsGrid
//! =========================================================

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

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth > 700) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 480) {
              crossAxisCount = 3;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.15,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              itemCount: state.slots.length,
              itemBuilder: (context, index) {
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
                  onTap: () => cubit.selectSlot(index),
                );
              },
            );
          },
        );
      },
    );
  }
}
