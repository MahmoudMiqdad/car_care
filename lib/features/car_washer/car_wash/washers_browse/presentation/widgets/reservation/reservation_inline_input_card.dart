import 'package:car_care/core/extensions/theme_extension.dart'; // 🎯 استيراد امتداد الثيم لقراءة الخطوط الذكية
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationInlineInputCard extends StatelessWidget {
  const ReservationInlineInputCard({
    super.key,
    required this.leading,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final Widget leading;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.carWashTeal, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.centerStart, // 🎯 محاذاة ذكية تدعم الانعكاس التلقائي للغات
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                leading,
                SizedBox(width: 4.w),
                Text(
                  label,
                  textAlign: TextAlign.start,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: controller,
            textAlign: TextAlign.start, // 🎯 يكتب العميل ويتحرك المؤشر بحسب لغة الكتابة الطبيعية
            keyboardType: keyboardType,
            minLines: minLines,
            maxLines: maxLines,
            style: context.textTheme.bodySmall!.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: context.textTheme.bodySmall!.copyWith(
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
