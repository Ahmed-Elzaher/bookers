import 'package:flutter_test/flutter_test.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source_impl.dart';
import 'package:bookers/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';

void main() {
  late BookingRepositoryImpl repository;
  late BookingLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = BookingLocalDataSourceImpl();
    repository = BookingRepositoryImpl(localDataSource: dataSource);
  });

  group('BookingRepositoryImpl Tests', () {
    test('getDailySchedule returns list of slots from data source', () {
      final schedule = repository.getDailySchedule();
      expect(schedule.length, equals(AppConstants.totalDaySlots));
      expect(schedule[0].status, equals(BookingStatus.available));
    });

    test('updateBooking updates slots via data source', () {
      final updated = repository.updateBooking([0, 1]);
      expect(updated[0].status, equals(BookingStatus.booked));
      expect(updated[1].status, equals(BookingStatus.booked));
    });

    test('createBookingTicket and getUserBookings flow works smoothly', () {
      final ticket = repository.createBookingTicket(
        bookedIndices: [0],
        duration: BookingDuration.thirtyMin,
        isArabic: true,
      );
      expect(ticket.id, contains('BK-'));
      expect(repository.getUserBookings().length, equals(1));
    });

    test('cancelBooking and resetSchedule delegate correctly', () {
      final ticket = repository.createBookingTicket(
        bookedIndices: [0],
        duration: BookingDuration.thirtyMin,
        isArabic: false,
      );
      repository.cancelBooking(ticket.id);
      expect(repository.getUserBookings(), isEmpty);

      final resetSlots = repository.resetSchedule();
      expect(resetSlots.length, equals(AppConstants.totalDaySlots));
    });
  });
}
