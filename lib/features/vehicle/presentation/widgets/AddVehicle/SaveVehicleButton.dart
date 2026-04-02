// ignore_for_file: file_names
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';

class SaveVehicleButton extends StatelessWidget {
  const SaveVehicleButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'حفظ المركبة',
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.orange,
      height: 54.h,
      borderRadius: 15.r,
      fontSize: 20.sp,
    );
  }
}