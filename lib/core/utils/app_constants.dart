import 'package:flutter_screenutil/flutter_screenutil.dart';


abstract class AppConstants {
  static const String appName = 'Booker';
  static const int totalDaySlots = 18;
  static const int dayStartHour = 9; // 9:00 AM
  static const int dayEndHour = 18; // 6:00 PM
  static const int slotDurationInMinutes = 30;

  // Design Canvas Standard Size
  static const double designWidth = 390.0;
  static const double designHeight = 844.0;

  // Unified Border Radii
  static double get radiusSmall => 8.r;
  static double get radiusMedium => 12.r;
  static double get radiusLarge => 16.r;
  static double get radiusModal => 24.r;

  // Unified Animations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
