// ignore_for_file: file_names

import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class UpdateActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const UpdateActionButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
    );
  }
}