import 'package:flutter/material.dart';

/// ملاحظة: هاد الملف أساسًا منظم منيح ومافيه علاقة بمشكلة "تفكك الأسطر"
/// (هاي كانت من AppTypography). ضفت بس شوية ثوابت ناقصة كانت مستخدمة
/// بملف الثيم الجديد (لون النص فوق الأزرار بالدارك مود، ولون error بالثيم).

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
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightTextPrimary = Color(0xFF161616);
  static const Color lightTextSecondary = Color(0xFF3D3A3B);
  static const Color lightBorder = Color(0xFFD0D5DD);

  static const Color darkPrimary = Color(0xFF428177);
  static const Color darkScaffold = Color(0xFF101828);
  static const Color darkSurface = Color(0xFF1D2939);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF98A2B3);
  static const Color darkBorder = Color(0xFF344054);

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
    return Theme.of(context).brightness == Brightness.dark ? darkScaffold : lightScaffold;
  }

  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkSurface : white;
  }

  /// جلب لون النصوص الأساسية والأسماء
  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;
  }

  /// جلب لون النصوص الثانوية والتلميحات
  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;
  }

  /// جلب لون الإطارات والحدود الفاصلة
  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkBorder : lightBorder;
  }
}