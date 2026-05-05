import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        Expanded(
          child: AppButton(
            onPressed: () {},
            text: context.l10n.bookingsMenuRateService,
            backgroundColor: AppColors.accent,
            textColor: AppColors.white,
            borderRadius: 12.r,
            fontSize: 18.sp,
            height: 46.h,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: AppButton(
            onPressed: () {},
            text: context.l10n.bookingsMenuCancelBooking,
            isOutline: true,
            backgroundColor: AppColors.primary,
            outlineSurfaceColor: AppColors.white,
            borderRadius: 12.r,
            fontSize: 18.sp,
            height: 46.h,
          ),
        ),
      ],
    );
  }
}
