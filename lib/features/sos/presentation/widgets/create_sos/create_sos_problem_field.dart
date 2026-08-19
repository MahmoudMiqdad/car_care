// ignore_for_file: deprecated_member_use

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateSosProblemField extends StatelessWidget {
  const CreateSosProblemField({
    super.key,
    required this.title,
    required this.controller,
    required this.hint,
  });

  final String title;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.edit_outlined, color: AppColors.primary, size: 22.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 2,
            textAlign: TextAlign.start,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary(context),
              fontSize: 14.sp,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: hint,
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary(context).withOpacity(0.55),
                fontSize: 14.sp,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
