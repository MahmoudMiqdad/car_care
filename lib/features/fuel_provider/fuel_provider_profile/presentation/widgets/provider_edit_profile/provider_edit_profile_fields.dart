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

class ProviderEditProfileSelectField extends StatelessWidget {
  const ProviderEditProfileSelectField({
    super.key,
    required this.label,
    required this.hint,
    required this.onTap,
    this.value,
  });

  final String label;
  final String hint;
  final VoidCallback onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value != null && value!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.carWashTeal, width: 1.2),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.carWashTeal,
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        hasValue ? value! : hint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: hasValue
                              ? AppColors.lightTextSecondary.withValues(
                                  alpha: 0.85,
                                )
                              : AppColors.lightTextSecondary.withValues(
                                  alpha: 0.55,
                                ),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
