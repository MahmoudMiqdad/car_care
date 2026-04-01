import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsSectionCard extends StatelessWidget {
  const OrderDetailsSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final r = AppConstants.sectionRadius;

    return AppBoxContainer(
      padding: EdgeInsets.zero, 
      borderRadius: r,
      borderColor: AppColors.primary,
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 35.h,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(r),
                topRight: Radius.circular(r),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
                    Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppConstants.sectionBodyPadding),
            child: child,
          ),
        ],
      ),
    );
  }
}