import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestsActionButtons extends StatelessWidget {
  const RequestsActionButtons({
    super.key,
    required this.cardRadius,
    required this.onSubmit,
    required this.onCancel,
  });

  final double cardRadius;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
  children: [
    Expanded(
      child: AppButton(
        text: 'طلب الصيانة',
        backgroundColor: AppColors.accent,
        borderRadius: 12.r,
        onPressed: () {},
      ),
    ),
    SizedBox(width: 12.w),
    Expanded(
      child: AppButton(
        text: 'إلغاء الطلب',
        isOutline: true,
        backgroundColor: AppColors.primary,
        borderRadius: 12.r,
        onPressed: () {},
      ),
    ),
  ],
);
  }
}
