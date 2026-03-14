// ignore_for_file: file_names
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleTextField extends StatefulWidget {
  final String hintText;
  final Widget iconWidget;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const VehicleTextField({
    super.key,
    required this.hintText,
    required this.iconWidget,
    this.controller,
    this.keyboardType,
  });

  @override
  State<VehicleTextField> createState() => _VehicleTextFieldState();
}

class _VehicleTextFieldState extends State<VehicleTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _isFocused ? AppColors.orange : AppColors.primary,
          width: _isFocused ? 2.w : 1.5.w,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.orange.withValues(alpha: 0.15),
                  blurRadius: 10.r,
                  spreadRadius: 1.r,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Expanded(
            child: AppTextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              textAlign: TextAlign.right,
              hintText: widget.hintText,
              hintStyle: context.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w700,
              ),
              contentPadding: EdgeInsets.only(bottom: 4.h),
            ),
          ),
          SizedBox(width: 16.w),
          AnimatedScale(
            scale: _isFocused ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: AnimatedOpacity(
              opacity: _isFocused ? 1.0 : 0.7,
              duration: const Duration(milliseconds: 250),
              child: widget.iconWidget,
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }
}