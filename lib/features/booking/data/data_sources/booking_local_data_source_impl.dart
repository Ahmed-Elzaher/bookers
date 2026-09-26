import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source.dart';
import 'package:bookers/features/booking/data/models/slot_model.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/user_booking_entity.dart';


class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl() {
    _slots = _generateInitialSlots();
  }

  late List<SlotModel> _slots;
  final List<UserBookingEntity> _userBookings = [];
  int _ticketCounter = 1;

  @override
  List<SlotModel> getDailySlots() {
    return List<SlotModel>.unmodifiable(_slots);
  }

  @override
  List<SlotModel> updateSlots(List<int> bookedIndices) {
    final updated = List<SlotModel>.from(_slots);
    for (final index in bookedIndices) {
      if (index >= 0 && index < AppConstants.totalDaySlots) {
        updated[index] = updated[index].copyWith(status: BookingStatus.booked);
      }
    }
    _slots = updated;
    return getDailySlots();
  }

  @override
  UserBookingEntity createBookingTicket({
    required List<int> bookedIndices,
    required BookingDuration duration,
    required bool isArabic,
  }) {
    final startSlot = _slots[bookedIndices.first];
    final endSlot = _slots[bookedIndices.last];
    final ticketId = 'BK-${_ticketCounter.toString().padLeft(3, '0')}';
    _ticketCounter++;

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final ticket = UserBookingEntity(
      id: ticketId,
      slotIndices: bookedIndices,
      startTimeFormatted: startSlot.startTimeFormatted,
      endTimeFormatted: endSlot.endTimeFormatted,
      durationLabel: isArabic ? duration.labelArabic : duration.labelEnglish,
      bookedAtFormatted: timeStr,
    );

    _userBookings.insert(0, ticket);
    return ticket;
  }

  @override
  List<UserBookingEntity> getUserBookings() {
    return List<UserBookingEntity>.unmodifiable(_userBookings);
  }

  @override
  List<SlotModel> cancelBooking(String bookingId) {
    final index = _userBookings.indexWhere((ticket) => ticket.id == bookingId);
    if (index != -1) {
      final ticket = _userBookings.removeAt(index);
      final updated = List<SlotModel>.from(_slots);
      for (final slotIndex in ticket.slotIndices) {
        if (slotIndex >= 0 && slotIndex < AppConstants.totalDaySlots) {
          updated[slotIndex] = updated[slotIndex].copyWith(status: BookingStatus.available);
        }
      }
      _slots = updated;
    }
    return getDailySlots();
  }

  @override
  List<SlotModel> resetDefaultSlots() {
    _slots = _generateInitialSlots();
    _userBookings.clear();
    _ticketCounter = 1;
    return getDailySlots();
  }

  /// جدول الـ 18 خانة الافتراضي:
  /// - يحفظ مثال التكليف (9:00، 9:30، 10:00 متاحة، و 10:30 محجوزة)
  /// - يتيح فترات متصلة كافية بعد الظهر لحجز ساعتين (4 خانات) بنجاح
  List<SlotModel> _generateInitialSlots() {
    final Map<int, BookingStatus> overrides = {
      3: BookingStatus.booked, // 10:30 - 11:00 ص (محجوز - مطابق لمثال التكليف)
      7: BookingStatus.unavailable, // 12:30 - 01:00 م (استراحة غداء)
    };

    return List<SlotModel>.generate(AppConstants.totalDaySlots, (index) {
      return SlotModel(
        index: index,
        status: overrides[index] ?? BookingStatus.available,
      );
    });
  }
}
