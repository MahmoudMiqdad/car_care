import 'package:flutter/material.dart';

/// Official color palette for the Government Digital Identity.
/// Each group represents a thematic tone for consistent branding.
class AppColors {
  static const Color primary = Color(0xFF006989);
  static const Color secondary = Color(0xFFf3f7ec);
  static const Color accent = Color(0xFFe88d67);

  // ☀️ Light Theme Palette
  static const Color lightPrimary = primary;
  static const Color lightScaffold = Color(0xFFedebe0); // Golden Wheat Light
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightTextPrimary = Color(0xFF161616); // Charcoal Dark
  static const Color lightTextSecondary = Color(0xFF3d3a3b);
  static const Color lightBorder = Color(0xFFD0D5DD);

  // 🌑 Dark Theme Palette
  static const Color darkPrimary = Color(
    0xFF428177,
  ); // Forest Light for better contrast
  static const Color darkScaffold = Color(0xFF101828);
  static const Color darkSurface = Color(0xFF1D2939);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF98A2B3);
  static const Color darkBorder = Color(0xFF344054);

  // 🚩--- (Common Colors) ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF232522);
  static const Color error = Color(0xffE25839);
  static const Color success = Color(0xff45B733);
  static const Color info = Color(0xFF2E90FA);
  static const Color warning = Color(0xffF5AE42);
  static const Color orange = Color(0xffe88d67);
  static const Color transparent = Colors.transparent;
}
