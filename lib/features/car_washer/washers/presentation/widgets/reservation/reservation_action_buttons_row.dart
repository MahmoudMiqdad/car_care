import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationActionButtonsRow extends StatelessWidget {
  const ReservationActionButtonsRow({
    super.key,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: AppButton(
            text: confirmText,
            onPressed: onConfirm,
            backgroundColor: AppColors.reservationConfirmOrange,
            fontSize: 15.sp,
            height: 48.h,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppButton(
            isOutline: true,
            text: cancelText,
            onPressed: onCancel,
            backgroundColor: AppColors.primary,
            textColor: AppColors.primary,
            outlineSurfaceColor: AppColors.white,
            fontSize: 15.sp,
            height: 48.h,
          ),
        ),
      ],
    );
  }
}
