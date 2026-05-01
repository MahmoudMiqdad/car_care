import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//// كتابة وجنبها >
/// Label + outlined tap target (date/time and similar) so reservation screens stay DRY.
class AppOutlinedSelectField extends StatelessWidget {
  const AppOutlinedSelectField({
    super.key,
    required this.valueText,
    required this.onTap,
    this.borderColor = AppColors.carWashTeal,
  });

  final String valueText;
  final VoidCallback onTap;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  valueText,
                  textAlign: TextAlign.right,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: borderColor,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
