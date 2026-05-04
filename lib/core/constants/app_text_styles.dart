import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle font20BlackBold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle font18BlackBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle font18BlackSemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle font15LightTextPrimarySemiBold = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
  );

  static TextStyle font13LightTextPrimarySemiBold = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
  );
}