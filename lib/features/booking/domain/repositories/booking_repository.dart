import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/entities/user_booking_entity.dart';


abstract class BookingRepository {
  /// جلب جدول اليوم الحالي
  List<SlotEntity> getDailySchedule();

  /// تطبيق الحجز الجديد على الخانات المحددة
  List<SlotEntity> updateBooking(List<int> bookedIndices);

  /// إضافة تذكرة حجز للمستخدم
  UserBookingEntity createBookingTicket({
    required List<int> bookedIndices,
    required BookingDuration duration,
    required bool isArabic,
  });

  /// جلب قائمة تذاكر الحجز المؤكدة الخاصة بالمستخدم
  List<UserBookingEntity> getUserBookings();

  /// إلغاء حجز معين وتحرير الخانات
  List<SlotEntity> cancelBooking(String bookingId);

  /// إعادة تعيين الجدول إلى الحالة الافتراضية
  List<SlotEntity> resetSchedule();
}
