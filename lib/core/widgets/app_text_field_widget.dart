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
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final void Function(String)? onChanged;

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
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontSize: 14.sp,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
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
