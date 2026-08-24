import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/widgets/app_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.iconPath,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.errorText,
    this.innerBorderColor,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final String? iconPath;
  final bool isPassword;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final String? errorText;
  final String? Function(String?)? validator;

  final Color? innerBorderColor;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final bool hasError = widget.errorText != null;

    final Color borderColor = hasError
        ? colorScheme.error
        : _isFocused
        ? colorScheme.primary
        : colorScheme.primary.withValues(alpha: 0.85);

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: AppTextField(
        controller: widget.controller,
        hintText: widget.hintText,
        isPassword: widget.isPassword,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        validator: widget.validator,
        errorText: widget.errorText,
        borderColor: widget.innerBorderColor ?? borderColor,
        errorBorderColor: widget.innerBorderColor ?? borderColor,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: widget.iconPath != null
              ? Image.asset(
                  widget.iconPath!,
                  width: 22.w,
                  height: 22.h,
                  color: borderColor,
                )
              : Icon(widget.icon, size: 22.sp, color: borderColor),
        ),
      ),
    );
  }
}
