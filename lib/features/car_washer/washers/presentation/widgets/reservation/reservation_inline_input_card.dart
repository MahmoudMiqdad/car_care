import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
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
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                leading,
                SizedBox(width: 4.w),
                Text(
                  label,
                  textAlign: TextAlign.right,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: keyboardType,
            minLines: minLines,
            maxLines: maxLines,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.bodySmall.copyWith(
                color: const Color.fromARGB(255, 114, 106, 108),
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
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
