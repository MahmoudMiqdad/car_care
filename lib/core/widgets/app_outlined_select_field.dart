import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// حقل اختيار خارجي محاط بإطار قابل لإعادة الاستخدام (تاريخ/وقت وخلافه)
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
                  textAlign: TextAlign.start, 
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp, 
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
              
                isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
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
