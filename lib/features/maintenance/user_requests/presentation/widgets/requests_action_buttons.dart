import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum RequestsActionButtonsLayout {
  row,
  column,
}

class RequestsActionButtons extends StatelessWidget {
  const RequestsActionButtons({
    super.key,
    required this.cardRadius,
    required this.onSubmit,
    required this.onCancel,
    this.submitLabel = 'طلب الصيانة',
    this.cancelLabel = 'إلغاء الطلب',
    this.layout = RequestsActionButtonsLayout.row,
    this.submitBackgroundColor,
    this.cancelOutlineSurfaceColor,
    this.cancelTextColor,
  });

  final double cardRadius;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final String submitLabel;
  final String cancelLabel;
  final RequestsActionButtonsLayout layout;
  final Color? submitBackgroundColor;
  final Color? cancelOutlineSurfaceColor;
  final Color? cancelTextColor;

  @override
  Widget build(BuildContext context) {
    final submit = AppButton(
      text: submitLabel,
      backgroundColor: submitBackgroundColor ?? AppColors.accent,
      borderRadius: cardRadius,
      onPressed: onSubmit,
    );
    final cancel = AppButton(
      text: cancelLabel,
      isOutline: true,
      backgroundColor: AppColors.primary,
      borderRadius: cardRadius,
      onPressed: onCancel,
      outlineSurfaceColor: cancelOutlineSurfaceColor,
      textColor: cancelTextColor,
    );

    if (layout == RequestsActionButtonsLayout.column) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          submit,
          SizedBox(height: 12.h),
          cancel,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: submit),
        SizedBox(width: 12.w),
        Expanded(child: cancel),
      ],
    );
  }
}
