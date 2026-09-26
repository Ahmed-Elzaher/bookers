import 'package:flutter_test/flutter_test.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source_impl.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/use_cases/get_all_alternatives_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';

void main() {
  late GetAllAlternativesUseCase getAllAlternativesUseCase;
  late BookingLocalDataSourceImpl dataSource;

  setUp(() {
    const validateBookingUseCase = ValidateBookingUseCase();
    getAllAlternativesUseCase = const GetAllAlternativesUseCase(
      validateBookingUseCase: validateBookingUseCase,
    );
    dataSource = BookingLocalDataSourceImpl();
  });

  group('GetAllAlternativesUseCase Tests', () {
    test('returns all valid start indices for thirtyMin duration', () {
      final slots = dataSource.getDailySlots();
      final alternatives = getAllAlternativesUseCase(
        duration: BookingDuration.thirtyMin,
        currentSlots: slots,
      );
      // Slots 3 (booked) and 7 (unavailable) cannot start.
      expect(alternatives.contains(3), isFalse);
      expect(alternatives.contains(7), isFalse);
      expect(alternatives.isNotEmpty, isTrue);
    });

    test('returns valid starts for twoHours duration without gap or bounds issues', () {
      final slots = dataSource.getDailySlots();
      final alternatives = getAllAlternativesUseCase(
        duration: BookingDuration.twoHours,
        currentSlots: slots,
      );
      // Slot 8 (1:00 PM) has slots 8, 9, 10, 11 available, so it is a valid start.
      expect(alternatives.contains(8), isTrue);
      // Slot 16 cannot start 2 hours because only 2 slots remain until 6:00 PM.
      expect(alternatives.contains(16), isFalse);
    });
  });
}
