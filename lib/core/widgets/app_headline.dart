import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final AlignmentGeometry? alignment;

  const AppText._({
    required this.text,
    required this.style,
    this.textAlign,
    this.alignment,
  });

  factory AppText.headline(BuildContext context, String text, {Color? color}) {
    return AppText._(
      text: text,
      textAlign: TextAlign.start,
      alignment: AlignmentDirectional.centerStart,
      style: context.textTheme.headlineMedium!.copyWith(
        color: color ?? AppColors.primary,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
    );
  }

  factory AppText.sectionTitle(
    BuildContext context, 
    String text, {
    Color? color,
    TextAlign? textAlign,
    AlignmentGeometry? alignment,
    double? fontSize, 
    FontWeight? fontWeight,
  }) {
    return AppText._(
      text: text,
      alignment: alignment ?? AlignmentDirectional.centerStart,
      textAlign: textAlign ?? TextAlign.start,
      style: context.textTheme.bodyMedium!.copyWith(
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: fontSize, // 🎯 يتم جلب الحجم تلقائياً من الـ Theme المناسب للغة دون هدر برميجي
        color: color ?? AppColors.textPrimary(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: alignment ?? AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}