enum BookingStatus {
  available,
  booked,
  unavailable,
  selected;

  bool get isBlocked =>
      this == BookingStatus.booked || this == BookingStatus.unavailable;

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

  String get labelEnglish {
    switch (this) {
      case BookingStatus.available:
        return 'Available';
      case BookingStatus.booked:
        return 'Booked';
      case BookingStatus.unavailable:
        return 'Unavailable';
      case BookingStatus.selected:
        return 'Selected';
    }
  }
}
