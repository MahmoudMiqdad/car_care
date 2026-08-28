// ignore_for_file: deprecated_member_use
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
    final isDarkOrdinaryCta = !isOutline && backgroundColor == null && isDark;

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
    final primaryColor = disabled ? Colors.grey.shade400 : (backgroundColor ?? AppColors.accent);
    final resolvedTextColor = textColor ?? AppColors.white;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        elevation: disabled ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
      ),
      onPressed: disabled ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: 8.w),
                ],
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: resolvedTextColor,
                      fontSize: fontSize ?? 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOutlineButton(BuildContext context, bool disabled) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: disabled ? Colors.grey : (backgroundColor ?? AppColors.accent)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 12.r)),
      ),
      onPressed: disabled ? null : onPressed,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: disabled ? Colors.grey : textColor),
      ),
    );
  }

  Widget _buildDarkOrdinaryOutlineButton(BuildContext context, bool disabled) {
    return _buildOutlineButton(context, disabled);
  }
}
