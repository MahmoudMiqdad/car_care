import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/image_background.dart'; // استيراد كلاس الخلفية الخاص بك
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_form_card.dart';

class RequestsFlowStyles {
  static final double formCardRadius = AppConstants.maintenanceRequestCardRadius.r;
  static Widget backgroundStack({required Widget child}) {
    return ImageBackground(child: child);
  }

  static Widget formTextFieldCard({
    required String title,
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return RequestsFormCard(
      cardRadius: formCardRadius,
      title: title,
      icon: icon,
      iconColor: AppColors.primary,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14.sp, height: 1.2),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.lightTextSecondary.withValues(alpha: 0.7),
            fontSize: 13.sp,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}