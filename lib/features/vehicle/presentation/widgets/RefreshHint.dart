import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RefreshHint extends StatelessWidget {
  const RefreshHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.refresh,
          color: AppColors.lightTextSecondary.withValues(alpha: 0.7),
          size: 32.sp,
        ),
        SizedBox(height: 6.h),
        Text(
          'تحديث قائمة السيارات...',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}