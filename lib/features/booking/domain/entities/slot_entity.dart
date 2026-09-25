import 'package:equatable/equatable.dart';
import 'package:bookers/core/utils/time_formatter.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';

//! =========================================================
//! Domain Entity: SlotEntity
//! =========================================================

class SlotEntity extends Equatable {
  const SlotEntity({
    required this.index,
    required this.status,
  });

  final int index;
  final BookingStatus status;

  /// الدقائق منذ منتصف الليل لوقت البداية
  int get startMinutes => TimeFormatter.slotIndexToStartMinutes(index);

  /// الدقائق منذ منتصف الليل لوقت النهاية
  int get endMinutes => TimeFormatter.slotIndexToEndMinutes(index);

  /// وقت البداية بنظام 12 ساعة
  String get startTimeFormatted => TimeFormatter.formatMinutesTo12H(startMinutes);

  /// وقت النهاية بنظام 12 ساعة
  String get endTimeFormatted => TimeFormatter.formatMinutesTo12H(endMinutes);

  /// نطاق الخانة بالكامل
  String get rangeFormatted => '$startTimeFormatted - $endTimeFormatted';

  bool get isAvailable => status == BookingStatus.available;
  bool get isBooked => status == BookingStatus.booked;
  bool get isUnavailable => status == BookingStatus.unavailable;
  bool get isSelected => status == BookingStatus.selected;

  SlotEntity copyWith({
    int? index,
    BookingStatus? status,
  }) {
    return SlotEntity(
      index: index ?? this.index,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [index, status];
}
