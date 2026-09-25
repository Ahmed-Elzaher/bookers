import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';

//! =========================================================
//! Use Case: FindAlternativeSlotUseCase
//! =========================================================

class FindAlternativeSlotUseCase {
  const FindAlternativeSlotUseCase({
    required this.validateBookingUseCase,
  });

  final ValidateBookingUseCase validateBookingUseCase;

  /// البحث عن أقرب خانة بداية صالحة للمدة المحددة
  int? call({
    required int attemptedIndex,
    required BookingDuration duration,
    required List<SlotEntity> currentSlots,
  }) {
    final validIndices = <int>[];

    for (int i = 0; i < AppConstants.totalDaySlots; i++) {
      final validationResult = validateBookingUseCase(
        startIndex: i,
        duration: duration,
        currentSlots: currentSlots,
      );

      if (validationResult.isRight()) {
        validIndices.add(i);
      }
    }

    if (validIndices.isEmpty) {
      return null;
    }

    int? nearest;
    int minDistance = AppConstants.totalDaySlots + 1;

    for (final index in validIndices) {
      final distance = (index - attemptedIndex).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearest = index;
      }
    }

    return nearest;
  }
}
