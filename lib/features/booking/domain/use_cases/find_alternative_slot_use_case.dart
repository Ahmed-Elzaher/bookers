import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/use_cases/get_all_alternatives_use_case.dart';

class FindAlternativeSlotUseCase {
  const FindAlternativeSlotUseCase({
    required this.getAllAlternativesUseCase,
  });

  final GetAllAlternativesUseCase getAllAlternativesUseCase;

  /// البحث عن أقرب خانة بداية صالحة للمدة المحددة
  int? call({
    required int attemptedIndex,
    required BookingDuration duration,
    required List<SlotEntity> currentSlots,
  }) {
    final validIndices = getAllAlternativesUseCase(
      duration: duration,
      currentSlots: currentSlots,
    );

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
