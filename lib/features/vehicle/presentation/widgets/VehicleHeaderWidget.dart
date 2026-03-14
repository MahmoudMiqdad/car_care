import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleHeaderWidget extends StatelessWidget {
  const VehicleHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15.r,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/car.png',
              width: 140.w,
              height: 140.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 140.w,
                  height: 140.w,
                  color: AppColors.lightBorder,
                  child: Icon(
                    Icons.directions_car,
                    size: 60.sp,
                    color: AppColors.orange,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'سابا ١٣٠',
          style: context.textTheme.headlineMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 32.sp,
          ),
        ),
        Text(
          'المالك : خالد الحميدات',
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }
}