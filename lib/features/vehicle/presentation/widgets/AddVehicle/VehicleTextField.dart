// ignore_for_file: file_names
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class VehicleTextField extends StatelessWidget {
  final String hintText;
  final Widget iconWidget;

  const VehicleTextField({
    super.key,
    required this.hintText,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary,
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          iconWidget,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                hintText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}