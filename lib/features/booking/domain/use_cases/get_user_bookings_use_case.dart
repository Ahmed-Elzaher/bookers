import 'package:bookers/features/booking/domain/entities/user_booking_entity.dart';
import 'package:bookers/features/booking/domain/repositories/booking_repository.dart';


class GetUserBookingsUseCase {
  const GetUserBookingsUseCase({required this.repository});

  final BookingRepository repository;

  List<UserBookingEntity> call() {
    return repository.getUserBookings();
  }
}
