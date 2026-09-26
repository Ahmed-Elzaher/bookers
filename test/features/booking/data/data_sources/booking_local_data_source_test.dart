import 'package:flutter_test/flutter_test.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source_impl.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';

void main() {
  late BookingLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = BookingLocalDataSourceImpl();
  });

  group('BookingLocalDataSourceImpl Tests', () {
    test('1. Initial slots matches the task requirements', () {
      final slots = dataSource.getDailySlots();
      expect(slots.length, equals(AppConstants.totalDaySlots));
      expect(slots[0].status, equals(BookingStatus.available));
      expect(slots[3].status, equals(BookingStatus.booked)); // 10:30 AM
      expect(slots[7].status, equals(BookingStatus.unavailable)); // 12:30 PM
    });

    test('2. updateSlots updates status to booked for given indices', () {
      final updated = dataSource.updateSlots([0, 1]);
      expect(updated[0].status, equals(BookingStatus.booked));
      expect(updated[1].status, equals(BookingStatus.booked));
    });

    test('3. createBookingTicket correctly localizes duration in Arabic and English', () {
      final ticketAr = dataSource.createBookingTicket(
        bookedIndices: [0, 1],
        duration: BookingDuration.oneHour,
        isArabic: true,
      );
      expect(ticketAr.durationLabel, equals('ساعة واحدة'));

      final ticketEn = dataSource.createBookingTicket(
        bookedIndices: [4, 5],
        duration: BookingDuration.oneHour,
        isArabic: false,
      );
      expect(ticketEn.durationLabel, equals('1 Hour'));
      expect(ticketEn.id, contains('BK-'));
    });

    test('4. cancelBooking frees slots and removes ticket', () {
      final ticket = dataSource.createBookingTicket(
        bookedIndices: [0],
        duration: BookingDuration.thirtyMin,
        isArabic: true,
      );
      dataSource.updateSlots([0]);
      expect(dataSource.getDailySlots()[0].status, equals(BookingStatus.booked));

      final remaining = dataSource.cancelBooking(ticket.id);
      expect(remaining[0].status, equals(BookingStatus.available));
      expect(dataSource.getUserBookings(), isEmpty);
    });

    test('5. resetDefaultSlots resets back to initial seed and clears bookings', () {
      dataSource.updateSlots([0, 1]);
      dataSource.createBookingTicket(
        bookedIndices: [0, 1],
        duration: BookingDuration.oneHour,
        isArabic: true,
      );
      final reset = dataSource.resetDefaultSlots();
      expect(reset[0].status, equals(BookingStatus.available));
      expect(dataSource.getUserBookings(), isEmpty);
    });
  });
}
