import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/repositories/booking_repository.dart';


class ConfirmBookingUseCase {
  const ConfirmBookingUseCase({required this.repository});

  final BookingRepository repository;

  List<SlotEntity> call(List<int> bookedIndices) {
    return repository.updateBooking(bookedIndices);
  }
}
