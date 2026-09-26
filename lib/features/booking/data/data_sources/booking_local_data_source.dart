import 'package:bookers/features/booking/data/models/slot_model.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/user_booking_entity.dart';


abstract class BookingLocalDataSource {
  /// قراءة الجدول المحلي الحالي
  List<SlotModel> getDailySlots();

  /// تحديث حالة الخانات المحجوزة
  List<SlotModel> updateSlots(List<int> bookedIndices);

  /// إنشاء وتخزين تذكرة حجز للمستخدم
  UserBookingEntity createBookingTicket({
    required List<int> bookedIndices,
    required BookingDuration duration,
    required bool isArabic,
  });

  /// جلب حجوزات المستخدم المؤكدة
  List<UserBookingEntity> getUserBookings();

  /// إلغاء حجز محدد وتحرير خاناته
  List<SlotModel> cancelBooking(String bookingId);

  /// استعادة الجدول الافتراضي ومسح حجوزات المستخدم
  List<SlotModel> resetDefaultSlots();
}
