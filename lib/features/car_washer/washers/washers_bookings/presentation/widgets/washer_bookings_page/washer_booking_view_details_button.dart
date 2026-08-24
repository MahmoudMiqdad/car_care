import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherBookingViewDetailsButton extends StatelessWidget {
  const WasherBookingViewDetailsButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed ?? () {},
      text: context.l10n.washerBookingViewDetails,
      textColor: AppColors.white,
      height: 45.h,
      borderRadius: 10.r,
      fontSize: 24.sp,
    );
  }
}
