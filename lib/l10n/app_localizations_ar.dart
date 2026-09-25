// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Booker';

  @override
  String get appSubtitle => '9:00 ص إلى 6:00 م • 18 موعد محلي';

  @override
  String get available => 'متاح';

  @override
  String get selected => 'محدد';

  @override
  String get booked => 'محجوز';

  @override
  String get unavailable => 'استراحة';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get quickGuide => 'دليل الاستخدام';

  @override
  String get resetSchedule => 'إعادة ضبط الجدول';

  @override
  String get resetConfirmTitle => 'إعادة ضبط الجدول';

  @override
  String get resetConfirmMessage =>
      'هل أنت متأكد من رغبتك في إعادة ضبط جميع المواعيد إلى الحالة الافتراضية؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirmReset => 'نعم، إعادة ضبط';

  @override
  String get resetSuccess =>
      'تمت إعادة ضبط الجدول إلى الحالة الافتراضية بنجاح.';

  @override
  String get selectDuration => 'اختر مدة الحجز المطلوبة:';

  @override
  String get slotsCount => 'خانات';

  @override
  String get minutes => 'دقيقة';

  @override
  String get duration30m => '30 دقيقة';

  @override
  String get duration1h => 'ساعة واحدة';

  @override
  String get duration1_5h => 'ساعة ونصف';

  @override
  String get duration2h => 'ساعتان';

  @override
  String get startTime => 'وقت البداية';

  @override
  String get endTime => 'وقت النهاية';

  @override
  String get totalDuration => 'إجمالي المدة';

  @override
  String get confirmBooking => 'تأكيد الحجز الآن';

  @override
  String get selectValidSlot => 'اختر موعداً صالحاً';

  @override
  String get bookingSuccess => 'تم تأكيد حجزك بنجاح!';

  @override
  String get startSlotBadge => 'البداية';

  @override
  String get connectedSlotBadge => 'متابع';

  @override
  String get conflictTitle => 'تعارض وتداخل في الموعد';

  @override
  String get outOfBoundsTitle => 'تجاوز نهاية يوم العمل';

  @override
  String get isolatedGapTitle => 'فجوة زمنية معزولة (X O X)';

  @override
  String get invalidStartTitle => 'خانة غير صالحة للبدء';

  @override
  String get allAvailableAlternatives =>
      'جميع الأوقات البديلة المتاحة لهذه المدة:';

  @override
  String get noAlternativesFound =>
      'للأسف، لا توجد أي فترة تتسع لهذه المدة حالياً في اليوم.';

  @override
  String get chooseAnotherSlot => 'حسناً، سأختار موعداً آخر';

  @override
  String get myBookingsTitle => 'حجوزاتي المؤكدة';

  @override
  String get noBookingsYet => 'لا توجد حجوزات مؤكدة حتى الآن.';

  @override
  String get ticketNumber => 'تذكرة حجز';

  @override
  String get cancelBooking => 'إلغاء هذا الحجز';

  @override
  String get cancelSuccess => 'تم إلغاء الحجز وتحرير الموعد بنجاح.';

  @override
  String get tourTitle => 'دليل Booker الذكي';

  @override
  String get tourStep1Title => '1. اختر المدة المناسبة ⏱️';

  @override
  String get tourStep1Desc =>
      'حدد المدة المطلوبة من 30 دقيقة حتى ساعتين بمرونة تامة.';

  @override
  String get tourStep2Title => '2. اختر موعد البداية 📅';

  @override
  String get tourStep2Desc =>
      'اضغط على أي خانة متاحة، وسيفحص النظام تلقائياً عدم ترك فجوات معزولة (X O X).';

  @override
  String get tourStep3Title => '3. نظام البدائل الذكية 💡';

  @override
  String get tourStep3Desc =>
      'في حال تعارض موعدك، ستظهر نافذة تعرض كافة البدائل وتنقلك فورياً لموقعها.';

  @override
  String get tourStep4Title => '4. إدارة الحجوزات 🎟️';

  @override
  String get tourStep4Desc =>
      'استعرض تذاكرك في شاشة \"حجوزاتي\" مع إمكانية إلغاء أي حجز بنقرة واحدة.';

  @override
  String get gotIt => 'فهمت، لنبدأ!';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get changeLanguage => 'English';

  @override
  String get yourBooking => 'حجزك المؤكد';

  @override
  String get suggestedAlternative => 'بديل متاح مقترح لنفس المدة:';

  @override
  String get startsAt => 'يبدأ الساعة';

  @override
  String get applyAlternative => 'تطبيق البديل';
}
