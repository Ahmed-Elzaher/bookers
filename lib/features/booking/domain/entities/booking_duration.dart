
enum BookingDuration {
  thirtyMin(1, 30, '30 دقيقة', '30 Minutes', '30m'),
  oneHour(2, 60, 'ساعة واحدة', '1 Hour', '1h'),
  oneAndHalfHour(3, 90, 'ساعة ونصف', '1.5 Hours', '1.5h'),
  twoHours(4, 120, 'ساعتان', '2 Hours', '2h');
  

  const BookingDuration(
    this.slotCount,
    this.totalMinutes,
    this.labelArabic,
    this.labelEnglish,
    this.shortCode,
  );

  final int slotCount;
  final int totalMinutes;
  final String labelArabic;
  final String labelEnglish;
  final String shortCode;
}
