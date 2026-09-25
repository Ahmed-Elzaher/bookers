import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';

//! =========================================================
//! Use Case: GetAllAlternativesUseCase
//! =========================================================

class GetAllAlternativesUseCase {
  const GetAllAlternativesUseCase({
    required this.validateBookingUseCase,
  });

  final ValidateBookingUseCase validateBookingUseCase;

  /// استخراج جميع الخانات البديلة الصالحة للمدة المحددة
  List<int> call({
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

    return validIndices;
  }
}
