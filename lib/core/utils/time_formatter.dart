import 'package:bookers/core/utils/app_constants.dart';


abstract class TimeFormatter {
  /// يحسب الدقائق منذ منتصف الليل بناءً على مؤشر الخانة (0..17)
  static int slotIndexToStartMinutes(int slotIndex) {
    return (AppConstants.dayStartHour * 60) + (slotIndex * AppConstants.slotDurationInMinutes);
  }

  /// يحسب دقائق نهاية الخانة
  static int slotIndexToEndMinutes(int slotIndex, {int slotSpan = 1}) {
    return slotIndexToStartMinutes(slotIndex) + (slotSpan * AppConstants.slotDurationInMinutes);
  }

  /// تحويل الدقائق منذ منتصف الليل إلى صيغة 12 ساعة (مثال: 9:00 ص أو 1:30 م)
  static String formatMinutesTo12H(int totalMinutes, {bool arabic = true}) {
    final int hours24 = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;

    final String periodArabic = hours24 < 12 ? 'ص' : 'م';
    final String periodEnglish = hours24 < 12 ? 'AM' : 'PM';

    int hours12 = hours24 % 12;
    if (hours12 == 0) {
      hours12 = 12;
    }

    final String minutesStr = minutes.toString().padLeft(2, '0');

    if (arabic) {
      return '$hours12:$minutesStr $periodArabic';
    } else {
      return '$hours12:$minutesStr $periodEnglish';
    }
  }

  /// تحويل نطاق زمني كامل لنص
  static String formatSlotRange(int slotIndex, {int slotSpan = 1, bool arabic = true}) {
    final start = formatMinutesTo12H(slotIndexToStartMinutes(slotIndex), arabic: arabic);
    final end = formatMinutesTo12H(slotIndexToEndMinutes(slotIndex, slotSpan: slotSpan), arabic: arabic);
    return '$start - $end';
  }
}
