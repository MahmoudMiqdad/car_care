import 'package:car_care/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AppTypography {
  static String getFontFamily(String languageCode) {
    return languageCode == 'ar'
        ? AppAssets.arFontFamily
        : AppAssets.enFontFamily;
  }


  static double _fs(double size, String languageCode) {
   
    final double languageFactor = languageCode == 'ar' ? 1.0 : 0.95;
    return (size * languageFactor).sp;
  }

  // 📰 Headlines
  static TextStyle headlineLarge(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(28, languageCode),
    fontWeight: FontWeight.w700,
    height: 1.4, 
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle headlineMedium(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(22, languageCode),
    fontWeight: FontWeight.w600,
    height: 1.45,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle headlineSmall(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(20, languageCode),
    fontWeight: FontWeight.w500,
    height: 1.45,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // 📄 Body text
  static TextStyle bodyLarge(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(18, languageCode),
    fontWeight: FontWeight.w400,
    height: 1.65,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle bodyMedium(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(16, languageCode),
    fontWeight: FontWeight.w400,
    height: 1.65,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle bodySmall(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(14, languageCode),
    fontWeight: FontWeight.w400,
    height: 1.55,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // 🔘 Button & Labels
  static TextStyle labelLarge(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(16, languageCode),
    fontWeight: FontWeight.w600,
    letterSpacing: languageCode == 'ar' ? 0.0 : 0.3,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle labelMedium(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(14, languageCode),
    fontWeight: FontWeight.w500,
    height: 1.45,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle labelSmall(String languageCode, {String? text}) => TextStyle(
    fontSize: _fs(12, languageCode),
    fontWeight: FontWeight.w400,
    height: 1.35,
    leadingDistribution: TextLeadingDistribution.even,
  );
}