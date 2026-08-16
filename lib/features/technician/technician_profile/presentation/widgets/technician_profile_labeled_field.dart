import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Adds a visible label above [LoginTextField] so technicians see what a
/// field means before tapping it, instead of relying on hint text alone.
class TechnicianProfileLabeledField extends StatelessWidget {
  const TechnicianProfileLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.iconPath,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final String? iconPath;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 6.h),
        LoginTextField(
          controller: controller,
          hintText: label,
          icon: icon,
          iconPath: iconPath,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
