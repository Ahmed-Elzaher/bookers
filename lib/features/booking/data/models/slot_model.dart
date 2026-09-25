import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';

//! =========================================================
//! Data Model: SlotModel
//! =========================================================

class SlotModel extends SlotEntity {
  const SlotModel({
    required super.index,
    required super.status,
  });

  factory SlotModel.fromEntity(SlotEntity entity) {
    return SlotModel(
      index: entity.index,
      status: entity.status,
    );
  }

  SlotEntity toEntity() {
    return SlotEntity(
      index: index,
      status: status,
    );
  }

  @override
  SlotModel copyWith({
    int? index,
    BookingStatus? status,
  }) {
    return SlotModel(
      index: index ?? this.index,
      status: status ?? this.status,
    );
  }
}
