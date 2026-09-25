import 'package:equatable/equatable.dart';

//! =========================================================
//! Domain Entity: UserBookingEntity
//! =========================================================

class UserBookingEntity extends Equatable {
  const UserBookingEntity({
    required this.id,
    required this.slotIndices,
    required this.startTimeFormatted,
    required this.endTimeFormatted,
    required this.durationLabel,
    required this.bookedAtFormatted,
  });

  final String id;
  final List<int> slotIndices;
  final String startTimeFormatted;
  final String endTimeFormatted;
  final String durationLabel;
  final String bookedAtFormatted;

  int get startIndex => slotIndices.first;
  int get endIndex => slotIndices.last;

  @override
  List<Object?> get props => [
        id,
        slotIndices,
        startTimeFormatted,
        endTimeFormatted,
        durationLabel,
        bookedAtFormatted,
      ];
}
