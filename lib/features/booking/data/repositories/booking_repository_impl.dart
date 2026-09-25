import 'package:bookers/features/booking/data/data_sources/booking_local_data_source.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/entities/user_booking_entity.dart';
import 'package:bookers/features/booking/domain/repositories/booking_repository.dart';

//! =========================================================
//! Repository Implementation: BookingRepositoryImpl
//! =========================================================

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl({
    required this.localDataSource,
  });

  final BookingLocalDataSource localDataSource;

  @override
  List<SlotEntity> getDailySchedule() {
    return localDataSource.getDailySlots();
  }

  @override
  List<SlotEntity> updateBooking(List<int> bookedIndices) {
    return localDataSource.updateSlots(bookedIndices);
  }

  @override
  UserBookingEntity createBookingTicket({
    required List<int> bookedIndices,
    required BookingDuration duration,
    required bool isArabic,
  }) {
    return localDataSource.createBookingTicket(
      bookedIndices: bookedIndices,
      duration: duration,
      isArabic: isArabic,
    );
  }

  @override
  List<UserBookingEntity> getUserBookings() {
    return localDataSource.getUserBookings();
  }

  @override
  List<SlotEntity> cancelBooking(String bookingId) {
    return localDataSource.cancelBooking(bookingId);
  }

  @override
  List<SlotEntity> resetSchedule() {
    return localDataSource.resetDefaultSlots();
  }
}
