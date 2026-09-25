import 'package:flutter/material.dart';

//! =========================================================
//! Application Color Palette
//! =========================================================

abstract class AppColors {
  // Pure & Neutral
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Backgrounds & Surface
  static const Color background = Color(0xFF0F172A); // Dark Slate 900
  static const Color surface = Color(0xFF1E293B); // Slate 800
  static const Color surfaceSubtle = Color(0xFF334155); // Slate 700
  static const Color cardHover = Color(0xFF283548);

  // Brand Accent (Royal Indigo / Violet)
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo 600

  // Status: Available (Emerald Green)
  static const Color available = Color(0xFF10B981);
  static const Color availableLight = Color(0xFF34D399);
  static const Color availableBg = Color(0xFF064E3B);
  static const Color availableBorder = Color(0xFF059669);

  // Status: Booked (Rose / Coral)
  static const Color booked = Color(0xFFF43F5E);
  static const Color bookedLight = Color(0xFFFB7185);
  static const Color bookedBg = Color(0xFF4C0519);
  static const Color bookedBorder = Color(0xFFE11D48);

  // Status: Unavailable (Muted Slate / Gray)
  static const Color unavailable = Color(0xFF64748B);
  static const Color unavailableBg = Color(0xFF1E293B);
  static const Color unavailableBorder = Color(0xFF475569);

  // Status: Selected
  static const Color selected = Color(0xFF6366F1);
  static const Color selectedGlow = Color(0x666366F1);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Validation Warnings & Alerts
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFF451A03);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFF450A0A);
}
