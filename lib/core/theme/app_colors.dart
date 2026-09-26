import 'package:flutter/material.dart';


abstract class AppColors {
  // Pure & Neutral
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Backgrounds & Surface (Modern Clean Light Slate)
  static const Color background = Color(0xFFF8FAFC); // Slate 50 ultra-clean soft background
  static const Color surface = Color(0xFFFFFFFF); // Pure White cards
  static const Color surfaceSubtle = Color(0xFFE2E8F0); // Slate 200 crisp delicate border
  static const Color cardHover = Color(0xFFF1F5F9); // Slate 100

  // Brand Accent (Royal Indigo)
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800

  // Status: Available (Fresh Emerald Green)
  static const Color available = Color(0xFF059669); // Emerald 600
  static const Color availableLight = Color(0xFF10B981); // Emerald 500
  static const Color availableBg = Color(0xFFECFDF5); // Emerald 50 soft tint
  static const Color availableBorder = Color(0xFFA7F3D0); // Emerald 200

  // Status: Booked (Soft Rose / Coral)
  static const Color booked = Color(0xFFE11D48); // Rose 600
  static const Color bookedLight = Color(0xFFF43F5E); // Rose 500
  static const Color bookedBg = Color(0xFFFFF1F2); // Rose 50 soft tint
  static const Color bookedBorder = Color(0xFFFECDD3); // Rose 200

  // Status: Unavailable (Muted Slate)
  static const Color unavailable = Color(0xFF64748B); // Slate 500
  static const Color unavailableBg = Color(0xFFF1F5F9); // Slate 100
  static const Color unavailableBorder = Color(0xFFCBD5E1); // Slate 300

  // Status: Selected
  static const Color selected = Color(0xFF4F46E5);
  static const Color selectedGlow = Color(0x334F46E5);

  // Text Colors (High Contrast WCAG AAA on Light Backgrounds)
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900 for dark, crisp typography
  static const Color textSecondary = Color(0xFF475569); // Slate 600 for clean subtitles
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400 for tertiary hints

  // Validation Warnings & Alerts
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningBg = Color(0xFFFFFBEB); // Amber 50
  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color errorBg = Color(0xFFFEF2F2); // Red 50
}

