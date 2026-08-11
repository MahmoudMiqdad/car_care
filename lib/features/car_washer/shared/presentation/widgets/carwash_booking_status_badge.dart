import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

({Color background, Color border}) carwashBookingStatusStyleFor(String status) {
  switch (status) {
    case 'completed':
      return (
        background: AppColors.serviceTierSelectedBackground,
        border: AppColors.success,
      );
    case 'cancelled':
      return (background: const Color(0xFFF8D7DA), border: AppColors.error);
    default: // pending / accepted / in_progress
      return (background: Colors.transparent, border: AppColors.lightBorder);
  }
}

class CarwashBookingStatusBadge extends StatelessWidget {
  const CarwashBookingStatusBadge({
    super.key,
    required this.status,
    required this.label,
    this.fontSize = 15,
    this.verticalPadding = 4,
    this.horizontalPadding = 10,
  });

  final String status;
  final String label;

  /// Kept per-caller so each existing wrapper can reproduce its own exact
  /// current sizing without any visual change.
  final double fontSize;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final style = carwashBookingStatusStyleFor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.w,
        vertical: verticalPadding.h,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: style.border, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
    );
  }
}
