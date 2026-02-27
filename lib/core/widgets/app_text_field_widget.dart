import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final void Function(String)? onChanged;
  final String? errorText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: context.textTheme.bodyLarge?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        errorText: widget.errorText, // 🔥 هذا المهم
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        border: InputBorder.none,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () =>
                    setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText
                      ? IconsaxPlusLinear.eye
                      : IconsaxPlusLinear.eye_slash,
                  size: 20.sp,
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}