// ignore_for_file: deprecated_member_use

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';

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

    this.outlineSurfaceColor,
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
  final Color? outlineSurfaceColor;

  @override
  Widget build(BuildContext context) {
    final isActionDisabled = isDisabled || isLoading || onPressed == null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDarkOrdinaryCta =
        !isOutline && backgroundColor == null && isDark;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: isDarkOrdinaryCta
          ? _buildDarkOrdinaryOutlineButton(context, isActionDisabled)
          : isOutline
          ? _buildOutlineButton(context, isActionDisabled)
          : _buildElevatedButton(context, isActionDisabled),
    );
  }

  Widget _buildElevatedButton(BuildContext context, bool disabled) {
    final primaryColor = backgroundColor ?? AppColors.accent;
    final resolvedTextColor = textColor ?? AppColors.white;

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: resolvedTextColor,
        disabledBackgroundColor: isLoading ? primaryColor : null,
        disabledForegroundColor: isLoading ? resolvedTextColor : null,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
      ),
      child: _buildButtonContent(
        context,
        textColorResolved: resolvedTextColor,
        spinnerColorResolved: resolvedTextColor,
      ),
    );
  }

  Widget _buildOutlineButton(BuildContext context, bool disabled) {
    final color = backgroundColor ?? context.colorScheme.primary;
    final resolvedTextColor = textColor ?? color;

    return OutlinedButton(
      onPressed: disabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: outlineSurfaceColor ?? color.withOpacity(0.1),
        foregroundColor: color,
        side: BorderSide(
          color: disabled && !isLoading ? color.withOpacity(0.5) : color,
          width: 1.5.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
      ),
      child: _buildButtonContent(
        context,
        textColorResolved: resolvedTextColor,
        spinnerColorResolved: color,
      ),
    );
  }

  Widget _buildDarkOrdinaryOutlineButton(BuildContext context, bool disabled) {
    const color = AppColors.accent;
    final resolvedTextColor = textColor ?? color;

    return OutlinedButton(
      onPressed: disabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: color,
        side: BorderSide(
          color: disabled && !isLoading ? color.withOpacity(0.5) : color,
          width: 1.5.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
      ),
      child: _buildButtonContent(
        context,
        textColorResolved: resolvedTextColor,
        spinnerColorResolved: resolvedTextColor,
      ),
    );
  }

  Widget _buildButtonContent(
    BuildContext context, {
    required Color textColorResolved,
    required Color spinnerColorResolved,
  }) {
    if (isLoading) {
      return SizedBox(
        height: 22.r,
        width: 22.r,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: spinnerColorResolved,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[icon!, 8.horizontalSpace],
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? 16.sp,
                color: textColorResolved,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
