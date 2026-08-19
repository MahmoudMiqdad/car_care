import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_field_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FuelSosCreateSelectField extends StatelessWidget {
  const FuelSosCreateSelectField({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.hint,
    required this.onTap,
    this.value,
  });

  final String iconAsset;
  final String title;
  final String hint;
  final VoidCallback onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value != null && value!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FuelSosCreateFieldIcon(assetPath: iconAsset),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        hasValue ? value! : hint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: hasValue
                              ? AppColors.textSecondary(context).withValues(
                                  alpha: 0.85,
                                )
                              : AppColors.textSecondary(context).withValues(
                                  alpha: 0.55,
                                ),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
