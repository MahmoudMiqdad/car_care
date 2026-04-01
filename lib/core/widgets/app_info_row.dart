import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//نص يكون بهذا الشكل ***:*** او 
//ايقونة ***:***
class AppInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final double? labelFontSize;
  final double? valueFontSize;

  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.labelFontSize,
    this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18.sp, color: AppColors.primary),
          SizedBox(width: 6.w),
        ],
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: labelFontSize ?? 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: valueFontSize ?? 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}