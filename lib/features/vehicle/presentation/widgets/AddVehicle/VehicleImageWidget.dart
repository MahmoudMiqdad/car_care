// ignore_for_file: file_names
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleImageWidget extends StatelessWidget {
  const VehicleImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      width: double.infinity,
      child: Image.asset(
        'assets/images/99.png',
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 250.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 50.sp,
              color: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}