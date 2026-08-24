import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF006989);
  static const Color secondary = Color(0xFFF3F7EC);
  static const Color accent = Color(0xFFE88D67);
  static const Color indigo = Color(0xFF6366F1);
  static const Color teal = Color(0xFF14B8A6);
  static const Color amber = Color(0xFFF59E0B);
  static const Color blue = Color(0xFF1E88E5);
  static const Color blueDark = Color(0xFF1565C0);
  static const Color orange = Colors.orange;
  static const Color orangeDark = Color(0xFFEF6C00);
  static const Color orange50 = Color(0xFFFFF3E0);
  static const Color green50 = Color(0xFFE8F5E9);
  static const Color green = Colors.green;
  static const Color red600 = Color(0xFFE53935);
  static const Color green700 = Color(0xFF388E3C);
  static const Color grey = Colors.grey;
  static const Color gray = Color.fromARGB(255, 114, 106, 108);
  static const Color pink = Color(0xFFEC4899);

  static const Color lightPrimary = primary;
  static const Color lightScaffold = Color(0xFFEDEBE0);
  static const Color lightTextPrimary = Color(0xFF161616);
  static const Color lightTextSecondary = Color(0xFF3D3A3B);
  static const Color lightBorder = Color(0xFFD0D5DD);

  static const Color darkPrimary = Color(0xFF0F6F7D);
  static const Color darkPrimaryInteractive = Color(0xFF168A99);
  static const Color darkScaffold = Color(0xFF0F1720);
  static const Color darkSurface = Color(0xFF182433);
  static const Color darkSecondarySurface = Color(0xFF223142);
  static const Color darkAppBarChrome = Color(0xFF111C26);
  static const Color darkTextPrimary = Color(0xFFF5F7FA);
  static const Color darkTextSecondary = Color(0xFFAEB8C2);
  static const Color darkBorder = Color(0xFF2E4354);
  static const Color darkSuccess = Color(0xFF4FA76C);
  static const Color darkWarning = Color(0xFFDFA24A);
  static const Color darkError = Color(0xFFD95D5D);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF232522);
  static const Color red = Color(0xFFE25839);
  static const Color success = Color(0xFF388E3C);
  static const Color errorBannerSurface = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF2E90FA);
  static const Color warning = Color(0xFFF5AE42);
  static const Color transparent = Colors.transparent;

  static const Color carWashTeal = Color(0xFF00607D);
  static const Color serviceTierSelectedBackground = Color(0xFFD9F7D9);
  static const Color reservationConfirmOrange = Color(0xFFE9967A);

  static Color scaffoldBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkScaffold
        : lightScaffold;
  }

  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : white;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorder
        : lightBorder;
  }

  static Color successColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSuccess
        : success;
  }

  static Color warningColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkWarning
        : warning;
  }
}
