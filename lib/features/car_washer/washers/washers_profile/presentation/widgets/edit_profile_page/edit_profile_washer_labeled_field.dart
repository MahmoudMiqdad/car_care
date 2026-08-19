import 'package:car_care/core/extensions/theme_extension.dart'; // 🎯 استيراد امتداد الثيم لقراءة الخطوط الذكية
import 'package:car_care/core/theme/app_colors.dart';
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
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final Widget? leadingIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart, 
          child: Text(
            label,
            style: context.textTheme.labelLarge!.copyWith( 
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        AppTextField(
          controller: controller,
          hintText: hint,
          borderColor: AppColors.border(context),
          hasShadow: false,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: minLines,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 11.h,
          ),
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
