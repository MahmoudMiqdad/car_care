import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderEditProfileActions extends StatelessWidget {
  const ProviderEditProfileActions({
    super.key,
    required this.saveLabel,
    required this.cancelLabel,
    this.onSave,
    this.onCancel,
  });

  final String saveLabel;
  final String cancelLabel;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          onPressed: onSave,
          text: saveLabel,
          backgroundColor: AppColors.orange,
          borderRadius: 28.r,
          height: 54.h,
          fontSize: 20.sp,
        ),
        SizedBox(height: 12.h),
        AppButton(
          onPressed: onCancel,
          text: cancelLabel,
          isOutline: true,
          backgroundColor: AppColors.carWashTeal,
          outlineSurfaceColor: AppColors.white,
          textColor: AppColors.carWashTeal,
          borderRadius: 28.r,
          height: 54.h,
          fontSize: 20.sp,
        ),
      ],
    );
  }
}
