// ignore_for_file: file_names

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RefreshHint extends StatelessWidget {
  const RefreshHint({
    super.key,
    this.onTap,
    this.hintText = 'تحديث قائمة السيارات...',
  });

  final VoidCallback? onTap;

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh,
              color: AppColors.lightTextSecondary.withValues(alpha: 0.7),
              size: 32.sp,
            ),
            SizedBox(height: 6.h),
            Text(
              hintText,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}