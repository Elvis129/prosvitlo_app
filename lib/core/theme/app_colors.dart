import 'package:flutter/material.dart';

/// App color palette following design system guidelines
class AppColors {
  /// Prevent instantiation
  const AppColors._();

  // Primary Yellow
  static const Color primaryYellow = Color(0xFFF6D66E);
  static const Color primaryYellowDark = Color(0xFFE5C55D);

  // Primary Blue
  static const Color primaryBlue50 = Color(0xFFEFF6FF);
  static const Color primaryBlue100 = Color(0xFFDBEAFE);
  static const Color primaryBlue600 = Color(0xFF2563EB);
  static const Color primaryBlue700 = Color(0xFF1D4ED8);

  /// Default primary blue (alias for primaryBlue600)
  static const Color primaryBlue = primaryBlue600;

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color success50 = Color(0xFFF0FDF4);
  static const Color success700 = Color(0xFF15803D);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warning50 = Color(0xFFFEFCE8);
  static const Color warning700 = Color(0xFFA16207);

  static const Color error = Color(0xFFEF4444);
  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error700 = Color(0xFFB91C1C);

  // Slate Gray
  static const Color slateGray50 = Color(0xFFF8FAFC);
  static const Color slateGray100 = Color(0xFFF1F5F9);
  static const Color slateGray200 = Color(0xFFE2E8F0);
  static const Color slateGray300 = Color(0xFFCBD5E1);
  static const Color slateGray400 = Color(0xFF94A3B8);
  static const Color slateGray500 = Color(0xFF64748B);
  static const Color slateGray600 = Color(0xFF475569);

  /// Default slate gray (alias for slateGray500)
  static const Color slateGray = slateGray500;
  static const Color slateGray700 = Color(0xFF334155);
  static const Color slateGray800 = Color(0xFF1E293B);
  static const Color slateGray900 = Color(0xFF0F172A);

  // Neutral Colors
  static const Color backgroundLight = Color(0xFFF1F1F4);
  static const Color backgroundLight2 = Color(0xFFDADCE0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1C1C1C);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textLightSecondary = Color(0xFFE0E0E0);
  static const Color textLightTertiary = Color(0xFFB0B0B0);
}
