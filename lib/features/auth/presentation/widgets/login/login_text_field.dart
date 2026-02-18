import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = _isFocused
        ? AppColors.lightPrimary
        : AppColors.lightPrimary.withValues(alpha: 0.85);

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor, width: 1.4),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.lightPrimary,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: AppTextField(
          controller: widget.controller,
          hintText: widget.hintText,
          isPassword: widget.isPassword,
          keyboardType: widget.keyboardType,
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: 14.w, left: 14.w),
            child: Icon(
              widget.icon,
              size: 22.sp,
              color: borderColor,
            ),
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}

