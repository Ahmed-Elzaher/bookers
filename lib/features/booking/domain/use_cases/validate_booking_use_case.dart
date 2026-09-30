import 'package:dartz/dartz.dart';
import 'package:bookers/core/errors/failures.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';

class ValidateBookingUseCase {
  const ValidateBookingUseCase();

  // Validates bounds, contiguity, and orphaned gap constraint
  Either<Failure, List<int>> call({
    required int startIndex,
    required BookingDuration duration,
    required List<SlotEntity> currentSlots,
  }) {
    if (startIndex < 0 || startIndex >= AppConstants.totalDaySlots) {
      return const Left(OutOfBoundsFailure());
    }

    final startSlot = currentSlots[startIndex];
    if (startSlot.status != BookingStatus.available) {
      return Left(InvalidStartFailure(startIndex: startIndex));
    }

    final int endIndex = startIndex + duration.slotCount - 1;
    if (endIndex >= AppConstants.totalDaySlots) {
      return const Left(OutOfBoundsFailure());
    }

    for (int i = startIndex; i <= endIndex; i++) {
      final slot = currentSlots[i];
      if (slot.status != BookingStatus.available) {
        return Left(OverlapFailure(conflictingIndex: i));
      }
    }

    // Check if this booking leaves an isolated 30-min slot (X O X pattern)
    final gapIndex = _findIsolatedGapAfterBooking(
      startIndex: startIndex,
      endIndex: endIndex,
      slots: currentSlots,
    );

    if (gapIndex != null) {
      return Left(IsolatedGapFailure(gapIndex: gapIndex));
    }

    final selectedIndices = List<int>.generate(
      duration.slotCount,
      (i) => startIndex + i,
    );
    return Right(selectedIndices);
  }

  int? _findIsolatedGapAfterBooking({
    required int startIndex,
    required int endIndex,
    required List<SlotEntity> slots,
  }) {
    final simulatedStatuses = List<BookingStatus>.generate(
      AppConstants.totalDaySlots,
      (i) => (i >= startIndex && i <= endIndex)
          ? BookingStatus.booked
          : slots[i].status,
    );

    bool isSlotIsolated(int i, List<BookingStatus> statuses) {
      if (statuses[i] != BookingStatus.available) return false;
      final bool leftBlocked = (i == 0) || statuses[i - 1].isBlocked;
      final bool rightBlocked =
          (i == AppConstants.totalDaySlots - 1) || statuses[i + 1].isBlocked;
      return leftBlocked && rightBlocked;
    }

    // Only check candidate neighbors directly affected by this booking:
    // Left candidate: startIndex - 1
    final leftCandidate = startIndex - 1;
    if (leftCandidate >= 0 &&
        isSlotIsolated(leftCandidate, simulatedStatuses)) {
      final wasAlreadyIsolated = isSlotIsolated(
        leftCandidate,
        slots.map((s) => s.status).toList(),
      );
      if (!wasAlreadyIsolated) {
        return leftCandidate;
      }
    }

    // Right candidate: endIndex + 1
    final rightCandidate = endIndex + 1;
    if (rightCandidate < AppConstants.totalDaySlots &&
        isSlotIsolated(rightCandidate, simulatedStatuses)) {
      final wasAlreadyIsolated = isSlotIsolated(
        rightCandidate,
        slots.map((s) => s.status).toList(),
      );
      if (!wasAlreadyIsolated) {
        return rightCandidate;
      }
    }

    return null;
  }
}
