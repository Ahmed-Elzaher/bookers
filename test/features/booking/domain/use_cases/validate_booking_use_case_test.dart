import 'package:flutter_test/flutter_test.dart';
import 'package:bookers/core/errors/failures.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source_impl.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';

void main() {
  group('ValidateBookingUseCase Clean Architecture Tests', () {
    late ValidateBookingUseCase useCase;
    late List<SlotEntity> slots;

    setUp(() {
      useCase = const ValidateBookingUseCase();
      final dataSource = BookingLocalDataSourceImpl();
      slots = dataSource.getDailySlots();
    });

    test('1. Day structure must have exactly 18 slots', () {
      expect(slots.length, equals(AppConstants.totalDaySlots));
      expect(slots.first.startTimeFormatted, equals('9:00 ص'));
      expect(slots.last.endTimeFormatted, equals('6:00 م'));
    });

    test('2. Bounds check prevents booking past 6:00 PM', () {
      // Slot 17 (5:30 - 6:00) with 1 hour (2 slots)
      final result = useCase(
        startIndex: 17,
        duration: BookingDuration.oneHour,
        currentSlots: slots,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<OutOfBoundsFailure>()),
        (r) => fail('Should fail'),
      );
    });

    test('3. Direct selection of booked or unavailable slot is rejected', () {
      // Slot 3 is pre-booked
      final resultBooked = useCase(
        startIndex: 3,
        duration: BookingDuration.thirtyMin,
        currentSlots: slots,
      );
      expect(resultBooked.isLeft(), isTrue);
      resultBooked.fold(
        (failure) {
          expect(failure, isA<InvalidStartFailure>());
          expect((failure as InvalidStartFailure).startIndex, equals(3));
        },
        (r) => fail('Should fail'),
      );

      // Slot 7 is unavailable
      final resultUnavailable = useCase(
        startIndex: 7,
        duration: BookingDuration.thirtyMin,
        currentSlots: slots,
      );
      expect(resultUnavailable.isLeft(), isTrue);
      resultUnavailable.fold(
        (failure) => expect(failure, isA<InvalidStartFailure>()),
        (r) => fail('Should fail'),
      );
    });

    test('4. Task Prompt Example: 9:00, 9:30, 10:00 available, 10:30 booked with 1 hour duration', () {
      // Confirm preconditions
      expect(slots[0].status, equals(BookingStatus.available)); // 9:00
      expect(slots[1].status, equals(BookingStatus.available)); // 9:30
      expect(slots[2].status, equals(BookingStatus.available)); // 10:00
      expect(slots[3].status, equals(BookingStatus.booked)); // 10:30

      // Case A: 1 hour from 9:00 leaves slot 2 (10:00) isolated between slot 1 and slot 3 -> X O X
      final resultStartAt0 = useCase(
        startIndex: 0,
        duration: BookingDuration.oneHour,
        currentSlots: slots,
      );
      expect(resultStartAt0.isLeft(), isTrue);
      resultStartAt0.fold(
        (failure) {
          expect(failure, isA<IsolatedGapFailure>());
          expect((failure as IsolatedGapFailure).gapIndex, equals(2));
        },
        (r) => fail('Should fail'),
      );

      // Case B: 1 hour from 9:30 leaves slot 0 (9:00) isolated between start of day and slot 1 -> X O X
      final resultStartAt1 = useCase(
        startIndex: 1,
        duration: BookingDuration.oneHour,
        currentSlots: slots,
      );
      expect(resultStartAt1.isLeft(), isTrue);
      resultStartAt1.fold(
        (failure) {
          expect(failure, isA<IsolatedGapFailure>());
          expect((failure as IsolatedGapFailure).gapIndex, equals(0));
        },
        (r) => fail('Should fail'),
      );

      // Case C: 1 hour from 10:00 collides with slot 3 -> Overlap
      final resultStartAt2 = useCase(
        startIndex: 2,
        duration: BookingDuration.oneHour,
        currentSlots: slots,
      );
      expect(resultStartAt2.isLeft(), isTrue);
      resultStartAt2.fold(
        (failure) {
          expect(failure, isA<OverlapFailure>());
          expect((failure as OverlapFailure).conflictingIndex, equals(3));
        },
        (r) => fail('Should fail'),
      );
    });

    test('5. Task Prompt Example: 1.5 hour from 9:00 (slots 0, 1, 2) is perfectly valid', () {
      final result = useCase(
        startIndex: 0,
        duration: BookingDuration.oneAndHalfHour,
        currentSlots: slots,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (selectedIndices) => expect(selectedIndices, equals([0, 1, 2])),
      );
    });

    test('6. Isolated gap at end of day (4:30 to 5:30 leaves 5:30 to 6:00 isolated)', () {
      final customSlots = List<SlotEntity>.generate(
        AppConstants.totalDaySlots,
        (i) => SlotEntity(index: i, status: BookingStatus.available),
      );

      final result = useCase(
        startIndex: 16,
        duration: BookingDuration.thirtyMin,
        currentSlots: customSlots,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<IsolatedGapFailure>());
          expect((failure as IsolatedGapFailure).gapIndex, equals(17));
        },
        (r) => fail('Should fail'),
      );
    });
  });
}
