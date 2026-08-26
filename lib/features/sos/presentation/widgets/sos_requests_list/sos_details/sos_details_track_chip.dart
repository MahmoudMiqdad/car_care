import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SosDetailsTrackChip extends StatelessWidget {
  const SosDetailsTrackChip({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.carWashTeal, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: Directionality.of(context),
            children: [
              Icon(
                Icons.chevron_left_rounded,
                size: 16.sp,
                color: colorScheme.onPrimary,
              ),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
