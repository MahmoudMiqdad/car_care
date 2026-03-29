import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_form_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProblemDescriptionField extends StatelessWidget {
  const ProblemDescriptionField({
    super.key,
     required this.cardRadius,
    required this.controller,
  });

  final double cardRadius;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return RequestsFormCard(
      cardRadius: cardRadius,
      title: 'وصف المشكلة',
      icon: Icons.edit_note,
      iconColor: AppColors.info,
      child: TextField(
        controller: controller,
        maxLines: 1,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'يرجى كتابة تفاصيل المشكلة هنا...',
          hintStyle: TextStyle(
            color: AppColors.lightTextSecondary.withValues(alpha: 0.7),
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(top: 8.h),
        ),
      ),
    );
  }
}
