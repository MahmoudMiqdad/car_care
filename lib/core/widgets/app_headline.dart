import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final AlignmentGeometry alignment;
  final TextDirection textDirection;

  const AppText._({
    required this.text,
    required this.style,
    required this.textAlign,
    required this.alignment,
    required this.textDirection,
  });

  factory AppText.headline(BuildContext context, String text, {Color? color}) {
    return AppText._(
      text: text,
      textDirection: TextDirection.ltr,
      alignment: AlignmentDirectional.centerEnd,
      textAlign: TextAlign.left,
      style: context.textTheme.headlineMedium!.copyWith(
        color: color ?? AppColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        letterSpacing: 0.4,
        height: 1.25,
      ),
    );
  }

  factory AppText.sectionTitle(
    String text, {
    Color? color,
    TextAlign textAlign = TextAlign.right,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,  int? fontsize,
  }) {
    return AppText._(
      text: text,
      textDirection: TextDirection.rtl,
      alignment: alignment,
      textAlign: textAlign,
      style: AppTypography.bodyMedium.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 20.sp,
        color: color ?? AppColors.lightTextPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Directionality(
        textDirection: textDirection,
        child: Text(
          text,
          style: style,
          textAlign: textAlign,
        ),
      ),
    );
  }
}