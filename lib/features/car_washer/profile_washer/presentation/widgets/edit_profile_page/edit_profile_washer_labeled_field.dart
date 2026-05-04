import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWasherLabeledField extends StatelessWidget {
  const EditProfileWasherLabeledField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.leadingIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.alignLabelToDirectionalStart = true,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final Widget? leadingIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;

  final bool alignLabelToDirectionalStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: alignLabelToDirectionalStart
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        AppTextField(
          controller: controller,
          hintText: hint,
          borderColor: AppColors.carWashTeal,
          hasShadow: false,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: minLines,
          prefixIcon: leadingIcon == null
              ? null
              : Padding(
                  padding: EdgeInsetsDirectional.only(start: 10.w, end: 4.w),
                  child: Align(
                    widthFactor: 1,
                    heightFactor: 1,
                    alignment: Alignment.center,
                    child: leadingIcon,
                  ),
                ),
        ),
      ],
    );
  }
}
