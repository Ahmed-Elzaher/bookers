import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'Booker'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'9:00 ص إلى 6:00 م • 18 موعد محلي'**
  String get appSubtitle;

  /// No description provided for @available.
  ///
  /// In ar, this message translates to:
  /// **'متاح'**
  String get available;

  /// No description provided for @selected.
  ///
  /// In ar, this message translates to:
  /// **'محدد'**
  String get selected;

  /// No description provided for @booked.
  ///
  /// In ar, this message translates to:
  /// **'محجوز'**
  String get booked;

  /// No description provided for @unavailable.
  ///
  /// In ar, this message translates to:
  /// **'استراحة'**
  String get unavailable;

  /// No description provided for @myBookings.
  ///
  /// In ar, this message translates to:
  /// **'حجوزاتي'**
  String get myBookings;

  /// No description provided for @quickGuide.
  ///
  /// In ar, this message translates to:
  /// **'دليل الاستخدام'**
  String get quickGuide;

  /// No description provided for @resetSchedule.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط الجدول'**
  String get resetSchedule;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط الجدول'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في إعادة ضبط جميع المواعيد إلى الحالة الافتراضية؟'**
  String get resetConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @confirmReset.
  ///
  /// In ar, this message translates to:
  /// **'نعم، إعادة ضبط'**
  String get confirmReset;

  /// No description provided for @resetSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت إعادة ضبط الجدول إلى الحالة الافتراضية بنجاح.'**
  String get resetSuccess;

  /// No description provided for @selectDuration.
  ///
  /// In ar, this message translates to:
  /// **'اختر مدة الحجز المطلوبة:'**
  String get selectDuration;

  /// No description provided for @slotsCount.
  ///
  /// In ar, this message translates to:
  /// **'خانات'**
  String get slotsCount;

  /// No description provided for @minutes.
  ///
  /// In ar, this message translates to:
  /// **'دقيقة'**
  String get minutes;

  /// No description provided for @duration30m.
  ///
  /// In ar, this message translates to:
  /// **'30 دقيقة'**
  String get duration30m;

  /// No description provided for @duration1h.
  ///
  /// In ar, this message translates to:
  /// **'ساعة واحدة'**
  String get duration1h;

  /// No description provided for @duration1_5h.
  ///
  /// In ar, this message translates to:
  /// **'ساعة ونصف'**
  String get duration1_5h;

  /// No description provided for @duration2h.
  ///
  /// In ar, this message translates to:
  /// **'ساعتان'**
  String get duration2h;

  /// No description provided for @startTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت البداية'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت النهاية'**
  String get endTime;

  /// No description provided for @totalDuration.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المدة'**
  String get totalDuration;

  /// No description provided for @confirmBooking.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحجز الآن'**
  String get confirmBooking;

  /// No description provided for @selectValidSlot.
  ///
  /// In ar, this message translates to:
  /// **'اختر موعداً صالحاً'**
  String get selectValidSlot;

  /// No description provided for @bookingSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد حجزك بنجاح!'**
  String get bookingSuccess;

  /// No description provided for @startSlotBadge.
  ///
  /// In ar, this message translates to:
  /// **'البداية'**
  String get startSlotBadge;

  /// No description provided for @connectedSlotBadge.
  ///
  /// In ar, this message translates to:
  /// **'متابع'**
  String get connectedSlotBadge;

  /// No description provided for @conflictTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعارض وتداخل في الموعد'**
  String get conflictTitle;

  /// No description provided for @outOfBoundsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تجاوز نهاية يوم العمل'**
  String get outOfBoundsTitle;

  /// No description provided for @isolatedGapTitle.
  ///
  /// In ar, this message translates to:
  /// **'فجوة زمنية معزولة (X O X)'**
  String get isolatedGapTitle;

  /// No description provided for @invalidStartTitle.
  ///
  /// In ar, this message translates to:
  /// **'خانة غير صالحة للبدء'**
  String get invalidStartTitle;

  /// No description provided for @allAvailableAlternatives.
  ///
  /// In ar, this message translates to:
  /// **'جميع الأوقات البديلة المتاحة لهذه المدة:'**
  String get allAvailableAlternatives;

  /// No description provided for @noAlternativesFound.
  ///
  /// In ar, this message translates to:
  /// **'للأسف، لا توجد أي فترة تتسع لهذه المدة حالياً في اليوم.'**
  String get noAlternativesFound;

  /// No description provided for @chooseAnotherSlot.
  ///
  /// In ar, this message translates to:
  /// **'حسناً، سأختار موعداً آخر'**
  String get chooseAnotherSlot;

  /// No description provided for @myBookingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'حجوزاتي المؤكدة'**
  String get myBookingsTitle;

  /// No description provided for @noBookingsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حجوزات مؤكدة حتى الآن.'**
  String get noBookingsYet;

  /// No description provided for @ticketNumber.
  ///
  /// In ar, this message translates to:
  /// **'تذكرة حجز'**
  String get ticketNumber;

  /// No description provided for @cancelBooking.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء هذا الحجز'**
  String get cancelBooking;

  /// No description provided for @cancelSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الحجز وتحرير الموعد بنجاح.'**
  String get cancelSuccess;

  /// No description provided for @tourTitle.
  ///
  /// In ar, this message translates to:
  /// **'دليل Booker الذكي'**
  String get tourTitle;

  /// No description provided for @tourStep1Title.
  ///
  /// In ar, this message translates to:
  /// **'1. اختر المدة المناسبة ⏱️'**
  String get tourStep1Title;

  /// No description provided for @tourStep1Desc.
  ///
  /// In ar, this message translates to:
  /// **'حدد المدة المطلوبة من 30 دقيقة حتى ساعتين بمرونة تامة.'**
  String get tourStep1Desc;

  /// No description provided for @tourStep2Title.
  ///
  /// In ar, this message translates to:
  /// **'2. اختر موعد البداية 📅'**
  String get tourStep2Title;

  /// No description provided for @tourStep2Desc.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على أي خانة متاحة، وسيفحص النظام تلقائياً عدم ترك فجوات معزولة (X O X).'**
  String get tourStep2Desc;

  /// No description provided for @tourStep3Title.
  ///
  /// In ar, this message translates to:
  /// **'3. نظام البدائل الذكية 💡'**
  String get tourStep3Title;

  /// No description provided for @tourStep3Desc.
  ///
  /// In ar, this message translates to:
  /// **'في حال تعارض موعدك، ستظهر نافذة تعرض كافة البدائل وتنقلك فورياً لموقعها.'**
  String get tourStep3Desc;

  /// No description provided for @tourStep4Title.
  ///
  /// In ar, this message translates to:
  /// **'4. إدارة الحجوزات 🎟️'**
  String get tourStep4Title;

  /// No description provided for @tourStep4Desc.
  ///
  /// In ar, this message translates to:
  /// **'استعرض تذاكرك في شاشة \"حجوزاتي\" مع إمكانية إلغاء أي حجز بنقرة واحدة.'**
  String get tourStep4Desc;

  /// No description provided for @gotIt.
  ///
  /// In ar, this message translates to:
  /// **'فهمت، لنبدأ!'**
  String get gotIt;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @changeLanguage.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get changeLanguage;

  /// No description provided for @yourBooking.
  ///
  /// In ar, this message translates to:
  /// **'حجزك المؤكد'**
  String get yourBooking;

  /// No description provided for @suggestedAlternative.
  ///
  /// In ar, this message translates to:
  /// **'بديل متاح مقترح لنفس المدة:'**
  String get suggestedAlternative;

  /// No description provided for @startsAt.
  ///
  /// In ar, this message translates to:
  /// **'يبدأ الساعة'**
  String get startsAt;

  /// No description provided for @applyAlternative.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق البديل'**
  String get applyAlternative;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
