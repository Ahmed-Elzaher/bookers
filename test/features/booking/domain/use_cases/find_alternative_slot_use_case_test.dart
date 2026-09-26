import 'package:flutter_test/flutter_test.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source_impl.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/use_cases/find_alternative_slot_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_all_alternatives_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';

void main() {
  late FindAlternativeSlotUseCase findAlternativeSlotUseCase;
  late BookingLocalDataSourceImpl dataSource;

  setUp(() {
    const validateBookingUseCase = ValidateBookingUseCase();
    const getAllAlternativesUseCase = GetAllAlternativesUseCase(
      validateBookingUseCase: validateBookingUseCase,
    );
    findAlternativeSlotUseCase = const FindAlternativeSlotUseCase(
      getAllAlternativesUseCase: getAllAlternativesUseCase,
    );
    dataSource = BookingLocalDataSourceImpl();
  });

  group('FindAlternativeSlotUseCase Tests', () {
    test('finds nearest valid alternative when user attempts a booked slot', () {
      final slots = dataSource.getDailySlots();
      // Slot 3 is booked (10:30 AM). For 30m, nearest valid slot could be 2 (10:00 AM) or 4 (11:00 AM).
      final nearest = findAlternativeSlotUseCase(
        attemptedIndex: 3,
        duration: BookingDuration.thirtyMin,
        currentSlots: slots,
      );
      expect(nearest, isNotNull);
      expect(nearest == 2 || nearest == 4, isTrue);
    });

    test('returns null if no alternatives fit the day', () {
      // Create full day of booked slots
      var slots = dataSource.getDailySlots();
      for (int i = 0; i < slots.length; i++) {
        slots = dataSource.updateSlots([i]);
      }
      final nearest = findAlternativeSlotUseCase(
        attemptedIndex: 5,
        duration: BookingDuration.oneHour,
        currentSlots: slots,
      );
      expect(nearest, isNull);
    });
  });
}
