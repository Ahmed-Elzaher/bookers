import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/repositories/booking_repository.dart';

//! =========================================================
//! Use Case: CancelBookingUseCase
//! =========================================================

class CancelBookingUseCase {
  const CancelBookingUseCase({required this.repository});

  final BookingRepository repository;

  List<SlotEntity> call(String bookingId) {
    return repository.cancelBooking(bookingId);
  }
}
