import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWasherActionsRow extends StatelessWidget {
  const EditProfileWasherActionsRow({
    super.key,
    required this.cancelLabel,
    required this.saveLabel,
    this.onCancel,
    this.onSave,
  });

  final String cancelLabel;
  final String saveLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: onSave,
            text: saveLabel,
            height: 50.h,
            borderRadius: 14.r,
            backgroundColor: AppColors.orange,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppButton(
            onPressed: onCancel,
            text: cancelLabel,
            isOutline: true,
            height: 50.h,
            borderRadius: 14.r,
            backgroundColor: AppColors.carWashTeal,
            outlineSurfaceColor: AppColors.white,
            textColor: AppColors.carWashTeal,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
