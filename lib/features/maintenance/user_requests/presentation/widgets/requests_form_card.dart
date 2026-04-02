import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RequestsFormCard extends StatelessWidget {
  const RequestsFormCard({
    super.key,
    required this.cardRadius,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final double cardRadius;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.symmetric(
          horizontal: 7.w, 
          vertical: 3.h,
        ),
         decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 23.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  fontSize: 19.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          child,
        ],
      ),
    );
  }
}
