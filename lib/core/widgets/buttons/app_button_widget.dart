// ignore_for_file: deprecated_member_use

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutline = false,
    this.borderRadius, 
    this.fontSize,
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final bool isOutline;
  final double? borderRadius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final isActionDisabled = isDisabled || isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity, 
      height: height ?? 50.h,         
      child: isOutline
          ? _buildOutlineButton(context, isActionDisabled)
          : _buildElevatedButton(context, isActionDisabled),
    );
  }

  Widget _buildElevatedButton(BuildContext context, bool disabled) {
    final primaryColor = backgroundColor ?? context.colorScheme.primary;

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor ?? AppColors.white,
        disabledBackgroundColor: isLoading ? primaryColor : null,
        disabledForegroundColor: isLoading ? (textColor ?? AppColors.white) : null,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildOutlineButton(BuildContext context, bool disabled) {
  final color = backgroundColor ?? context.colorScheme.primary;

  return OutlinedButton(
    onPressed: disabled ? null : onPressed,
    style: OutlinedButton.styleFrom(
      backgroundColor: color.withOpacity(0.1),
      
      foregroundColor: color,
      side: BorderSide(
        color: disabled && !isLoading ? color.withOpacity(0.5) : color, 
        width: 1.5.w,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
      ),
    ),
    child: _buildButtonContent(context),
  );
}
  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return AppLoadingWidget(
        size: 20.sp,
        color: isOutline ? (backgroundColor ?? context.colorScheme.primary) : AppColors.white,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          8.horizontalSpace,
        ],
        Text(
          text,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: fontSize ?? 16.sp, // استخدام الحجم الممرر أو الافتراضي
            color: isOutline
                ? (textColor ?? backgroundColor ?? context.colorScheme.primary)
                : (textColor ?? AppColors.white),
          ),
        ),
      ],
    );
  }
}