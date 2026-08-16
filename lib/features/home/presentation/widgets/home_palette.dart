// ألوان مرجعية خاصة بإعادة تصميم واجهة Home (HOME-UI-REDESIGN-01) فقط —
// قيم Hex محددة صراحة في المرجع التصميمي ولا تطابق ثوابت AppColors الحالية،
// لذا عُزلت هنا بدل تعديل الثيم المشترك (خارج نطاق هذه المهمة).
import 'package:flutter/material.dart';

class HomePalette {
  HomePalette._();

  static const Color primaryTeal = Color(0xFF006D85);
  static const Color textDark = Color(0xFF344D59);
  static const Color accentOrange = Color(0xFFEB8A63);

  static const List<Color> cardGradient = [
    Colors.white,
    Colors.white,
    Colors.white,
  ];
}
