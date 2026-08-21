import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateSosLocationHint extends StatelessWidget {
  const CreateSosLocationHint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, right: 4.w, bottom: 4.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.red,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
