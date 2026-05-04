import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWasherServiceTierCard extends StatelessWidget {
  const ProfileWasherServiceTierCard({
    super.key,
    required this.packageName,
    required this.priceLabel,
  });

  final String packageName;
  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.carWashTeal;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              packageName,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Divider(height: 1, thickness: 1, color: borderColor.withValues(alpha: 0.35)),
            SizedBox(height: 8.h),
            Text(
              priceLabel,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
