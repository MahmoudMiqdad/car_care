import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SosTechnicianDetailsSectionCard extends StatelessWidget {
  const SosTechnicianDetailsSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.bodyPadding,
    this.bodyHeight,
    this.clipBody = false,
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry? bodyPadding;
  final double? bodyHeight;
  final bool clipBody;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.r);

    final Widget body = Container(
      width: double.infinity,
      height: bodyHeight,
      padding: clipBody
          ? EdgeInsets.zero
          : (bodyPadding ?? EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h)),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
      ),
      clipBehavior: clipBody ? Clip.antiAlias : Clip.none,
      child: child,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: AppColors.carWashTeal, width: 1.2),
        color: context.colorScheme.surfaceContainer,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
            color: AppColors.carWashTeal,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
