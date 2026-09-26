import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/repositories/booking_repository.dart';


class GetDayScheduleUseCase {
  const GetDayScheduleUseCase({required this.repository});

  final BookingRepository repository;

  List<SlotEntity> call() {
    return repository.getDailySchedule();
  }
}
