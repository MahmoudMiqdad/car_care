import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SosTechnicianDetailsInfoRow extends StatelessWidget {
  const SosTechnicianDetailsInfoRow({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.value,
    this.iconSize,
  });

  final String iconAsset;
  final String label;
  final String value;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? 20.w;

    final labelStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w800,
      color: context.colorScheme.onSurface,
    );
    final valueStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: context.colorScheme.onSurface,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Image.asset(
              iconAsset,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.image_not_supported_outlined,
                size: size,
                color: AppColors.carWashTeal,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$label: ', style: labelStyle),
                  TextSpan(text: value, style: valueStyle),
                ],
              ),
              textDirection: TextDirection.rtl,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
