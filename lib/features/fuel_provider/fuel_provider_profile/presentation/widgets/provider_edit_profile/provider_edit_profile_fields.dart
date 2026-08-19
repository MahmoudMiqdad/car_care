import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderEditProfileFieldIcon extends StatelessWidget {
  const ProviderEditProfileFieldIcon({
    super.key,
    this.icon,
    this.assetPath,
  }) : assert(icon != null || assetPath != null);

  final IconData? icon;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: 36.r,
        height: 36.r,
        fit: BoxFit.contain,
      );
    }

    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.carWashTeal, width: 1.2),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: AppColors.carWashTeal,
        size: 22.sp,
      ),
    );
  }
}

class ProviderEditProfileInputField extends StatelessWidget {
  const ProviderEditProfileInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.leading,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.autofocus = false,
    this.focusNode,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget leading;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.carWashTeal, width: 1.2),
      ),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 4.h),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  minLines: 1,
                  maxLines: maxLines,
                  textAlign: TextAlign.start,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 14.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: hint,
                    hintStyle: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightTextSecondary.withValues(
                        alpha: 0.55,
                      ),
                      fontSize: 14.sp,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderEditProfileLocationNote extends StatelessWidget {
  const ProviderEditProfileLocationNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.error,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}
