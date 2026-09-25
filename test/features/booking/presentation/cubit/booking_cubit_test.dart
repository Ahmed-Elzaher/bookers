import 'package:flutter_test/flutter_test.dart';
import 'package:bookers/core/errors/failures.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source_impl.dart';
import 'package:bookers/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/use_cases/cancel_booking_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/confirm_booking_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/find_alternative_slot_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_all_alternatives_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_day_schedule_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_user_bookings_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/reset_schedule_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';

void main() {
  group('BookingCubit Clean Architecture Tests', () {
    late BookingCubit cubit;
    late BookingRepositoryImpl repository;

    setUp(() {
      final dataSource = BookingLocalDataSourceImpl();
      repository = BookingRepositoryImpl(localDataSource: dataSource);
      final getDayScheduleUseCase = GetDayScheduleUseCase(repository: repository);
      const validateBookingUseCase = ValidateBookingUseCase();
      final confirmBookingUseCase = ConfirmBookingUseCase(repository: repository);
      final resetScheduleUseCase = ResetScheduleUseCase(repository: repository);
      const findAlternativeSlotUseCase = FindAlternativeSlotUseCase(
        validateBookingUseCase: validateBookingUseCase,
      );
      const getAllAlternativesUseCase = GetAllAlternativesUseCase(
        validateBookingUseCase: validateBookingUseCase,
      );
      final getUserBookingsUseCase = GetUserBookingsUseCase(repository: repository);
      final cancelBookingUseCase = CancelBookingUseCase(repository: repository);

      cubit = BookingCubit(
        getDayScheduleUseCase: getDayScheduleUseCase,
        validateBookingUseCase: validateBookingUseCase,
        confirmBookingUseCase: confirmBookingUseCase,
        resetScheduleUseCase: resetScheduleUseCase,
        findAlternativeSlotUseCase: findAlternativeSlotUseCase,
        getAllAlternativesUseCase: getAllAlternativesUseCase,
        getUserBookingsUseCase: getUserBookingsUseCase,
        cancelBookingUseCase: cancelBookingUseCase,
        repository: repository,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('1. Initial state has 18 slots, thirtyMin duration, and Arabic enabled', () {
      expect(cubit.state.slots.length, equals(AppConstants.totalDaySlots));
      expect(cubit.state.selectedDuration, equals(BookingDuration.thirtyMin));
      expect(cubit.state.selectedStartIndex, isNull);
      expect(cubit.state.hasValidSelection, isFalse);
      expect(cubit.state.isArabic, isTrue);
      expect(cubit.state.userBookings, isEmpty);
    });

    test('2. Dynamic duration change triggers reactive revalidation', () {
      // Slot 0 with 1.5 hours is valid (0, 1, 2)
      cubit.setDuration(BookingDuration.oneAndHalfHour);
      cubit.selectSlot(0);
      expect(cubit.state.hasValidSelection, isTrue);
      expect(cubit.state.selectedIndices, equals({0, 1, 2}));

      // Switch to 1 hour triggers immediate revalidation!
      // Slot 0 for 1 hour leaves slot 2 as isolated gap before slot 3 (booked), so it fails!
      cubit.setDuration(BookingDuration.oneHour);
      expect(cubit.state.hasValidSelection, isFalse);
      expect(cubit.state.failure, isA<IsolatedGapFailure>());
    });

    test('3. 2-Hour duration booking succeeds on continuous slot block (Slot 8)', () {
      cubit.setDuration(BookingDuration.twoHours);
      cubit.selectSlot(8); // Slots 8, 9, 10, 11
      expect(cubit.state.hasValidSelection, isTrue);
      expect(cubit.state.selectedIndices, equals({8, 9, 10, 11}));

      final success = cubit.confirmBooking();
      expect(success, isTrue);
      expect(cubit.state.slots[8].status, equals(BookingStatus.booked));
      expect(cubit.state.slots[9].status, equals(BookingStatus.booked));
      expect(cubit.state.slots[10].status, equals(BookingStatus.booked));
      expect(cubit.state.slots[11].status, equals(BookingStatus.booked));
      expect(cubit.state.userBookings.length, equals(1));
    });

    test('4. Cancel booking frees slots and removes booking ticket', () {
      cubit.setDuration(BookingDuration.oneAndHalfHour);
      cubit.selectSlot(0);
      cubit.confirmBooking();

      expect(cubit.state.userBookings.length, equals(1));
      final bookingId = cubit.state.userBookings.first.id;

      cubit.cancelBooking(bookingId);

      expect(cubit.state.userBookings, isEmpty);
      expect(cubit.state.slots[0].status, equals(BookingStatus.available));
      expect(cubit.state.slots[1].status, equals(BookingStatus.available));
      expect(cubit.state.slots[2].status, equals(BookingStatus.available));
    });

    test('5. Toggle language switches between Arabic and English', () {
      expect(cubit.state.isArabic, isTrue);
      cubit.toggleLanguage();
      expect(cubit.state.isArabic, isFalse);
      cubit.toggleLanguage();
      expect(cubit.state.isArabic, isTrue);
    });

    test('6. Reset returns to initial default schedule', () {
      cubit.setDuration(BookingDuration.oneAndHalfHour);
      cubit.selectSlot(0);
      cubit.confirmBooking();
      expect(cubit.state.slots[0].status, equals(BookingStatus.booked));

      cubit.resetSchedule();
      expect(cubit.state.slots[0].status, equals(BookingStatus.available));
      expect(cubit.state.selectedStartIndex, isNull);
      expect(cubit.state.selectedDuration, equals(BookingDuration.thirtyMin));
      expect(cubit.state.userBookings, isEmpty);
    });
  });
}
