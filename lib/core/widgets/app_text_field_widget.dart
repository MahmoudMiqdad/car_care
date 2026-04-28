// ignore_for_file: deprecated_member_use

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
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
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.hintStyle,
    this.contentPadding,
    this.maxLines = 1,
    this.minLines,
    this.hasShadow = true,
    this.borderColor,
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
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final int maxLines;
  final int? minLines;
  final bool hasShadow;
  final Color? borderColor;

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
    final border = widget.borderColor ?? AppColors.primary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: widget.hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        textAlign: widget.textAlign,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        minLines: widget.isPassword ? null : widget.minLines,
        style: context.textTheme.bodyLarge?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? TextStyle(
            fontSize: 15.sp,
            color: const Color.fromARGB(255, 179, 170, 170),
          ),
          prefixIcon: widget.prefixIcon,
          errorText: widget.errorText,
          isDense: true,
          filled: true,
          fillColor: Colors.white, 
          contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: border, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: border, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon: Icon(
                    _obscureText ? IconsaxPlusLinear.eye : IconsaxPlusLinear.eye_slash,
                    size: 22.sp,
                    color: Colors.grey,
                  ),
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}