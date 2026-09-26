
enum BookingStatus {
  /// متاح للحجز
  available,

  /// محجوز مسبقاً
  booked,

  /// غير متاح للخدمة (خارج ساعات العمل أو استراحة)
  unavailable,

  /// تم اختياره حالياً
  selected;

  /// هل تعتبر الخانة عائقاً (محجوز أو غير متاح)
  bool get isBlocked => this == BookingStatus.booked || this == BookingStatus.unavailable;

  /// التسمية العربية
  String get labelArabic {
    switch (this) {
      case BookingStatus.available:
        return 'متاح';
      case BookingStatus.booked:
        return 'محجوز';
      case BookingStatus.unavailable:
        return 'غير متاح';
      case BookingStatus.selected:
        return 'محدد';
    }
  }
}
