import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

({Color background, Color border, Color foreground}) carwashBookingStatusStyleFor(
  BuildContext context,
  String status,
) {
  switch (status) {
    case 'completed':
      final color = AppColors.successColor(context);
      return (
        background: color.withValues(alpha: 0.12),
        border: color,
        foreground: color,
      );
    case 'cancelled':
      final color = context.colorScheme.error;
      return (
        background: color.withValues(alpha: 0.12),
        border: color,
        foreground: color,
      );
    case 'pending':
      final color = AppColors.warningColor(context);
      return (
        background: color.withValues(alpha: 0.12),
        border: color,
        foreground: color,
      );
    case 'in_progress':
      final color = context.colorScheme.primary;
      return (
        background: color.withValues(alpha: 0.12),
        border: color,
        foreground: color,
      );
    default:
      return (
        background: Colors.transparent,
        border: AppColors.border(context),
        foreground: context.colorScheme.onSurface,
      );
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

  final double fontSize;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final style = carwashBookingStatusStyleFor(context, status);

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
          color: style.foreground,
        ),
      ),
    );
  }
}
