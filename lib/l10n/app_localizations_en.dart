// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Booker';

  @override
  String get appSubtitle => '9:00 AM to 6:00 PM • 18 Local Slots';

  @override
  String get available => 'Available';

  @override
  String get selected => 'Selected';

  @override
  String get booked => 'Booked';

  @override
  String get unavailable => 'Break';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get quickGuide => 'Quick Guide';

  @override
  String get resetSchedule => 'Reset Schedule';

  @override
  String get resetConfirmTitle => 'Reset Schedule';

  @override
  String get resetConfirmMessage =>
      'Are you sure you want to reset all appointments back to default?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmReset => 'Yes, Reset';

  @override
  String get resetSuccess => 'Schedule successfully reset to default state.';

  @override
  String get selectDuration => 'Select Appointment Duration:';

  @override
  String get slotsCount => 'slots';

  @override
  String get minutes => 'mins';

  @override
  String get duration30m => '30 Minutes';

  @override
  String get duration1h => '1 Hour';

  @override
  String get duration1_5h => '1.5 Hours';

  @override
  String get duration2h => '2 Hours';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get totalDuration => 'Duration';

  @override
  String get confirmBooking => 'Confirm Booking Now';

  @override
  String get selectValidSlot => 'Select a valid slot';

  @override
  String get bookingSuccess => 'Your booking was confirmed successfully!';

  @override
  String get startSlotBadge => 'Start';

  @override
  String get connectedSlotBadge => 'Span';

  @override
  String get conflictTitle => 'Booking Conflict';

  @override
  String get outOfBoundsTitle => 'Exceeds Work Hours';

  @override
  String get isolatedGapTitle => 'Isolated Gap Constraint (X O X)';

  @override
  String get invalidStartTitle => 'Invalid Start Slot';

  @override
  String get allAvailableAlternatives =>
      'All available alternative slots for this duration:';

  @override
  String get noAlternativesFound =>
      'Unfortunately, no available slot can fit this duration today.';

  @override
  String get chooseAnotherSlot => 'Understood, choose another';

  @override
  String get myBookingsTitle => 'My Confirmed Bookings';

  @override
  String get noBookingsYet => 'No confirmed bookings yet.';

  @override
  String get ticketNumber => 'Booking Ticket';

  @override
  String get cancelBooking => 'Cancel this booking';

  @override
  String get cancelSuccess => 'Booking cancelled and slot freed successfully.';

  @override
  String get tourTitle => 'Smart Booker Guide';

  @override
  String get tourStep1Title => '1. Select Duration ⏱️';

  @override
  String get tourStep1Desc =>
      'Choose your required duration from 30 minutes to 2 hours flexibly.';

  @override
  String get tourStep2Title => '2. Select Start Slot 📅';

  @override
  String get tourStep2Desc =>
      'Tap any available slot. The system automatically enforces the (X O X) isolated gap rule.';

  @override
  String get tourStep3Title => '3. Smart Alternatives 💡';

  @override
  String get tourStep3Desc =>
      'If an overlap occurs, a modal displays all valid alternatives and scrolls you directly there.';

  @override
  String get tourStep4Title => '4. Manage Bookings 🎟️';

  @override
  String get tourStep4Desc =>
      'Review your tickets in \'My Bookings\' and cancel any reservation with one tap.';

  @override
  String get gotIt => 'Got it, let\'s start!';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get changeLanguage => 'العربية';

  @override
  String get yourBooking => 'Your Booking';

  @override
  String get suggestedAlternative =>
      'Suggested available slot for same duration:';

  @override
  String get startsAt => 'Starts at';

  @override
  String get applyAlternative => 'Apply Alternative';
}
