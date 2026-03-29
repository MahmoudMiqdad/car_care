import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleInfoSurface extends StatelessWidget {
  const VehicleInfoSurface({
    super.key,
    required this.borderRadius,
    required this.padding,
    required this.child,
    this.shadowBlur,
    this.shadowOpacity = 0.06,
    this.shadowOffset,
  });

  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final double? shadowBlur;
  final double shadowOpacity;
  final Offset? shadowOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowOpacity),
            blurRadius: shadowBlur ?? AppConstants.vehicleInfoSurfaceShadowBlur,
            offset: shadowOffset ?? Offset(0, 2.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class VehicleInfoPill extends StatelessWidget {
  const VehicleInfoPill({
    super.key,
    required this.borderRadius,
    required this.icon,
    required this.text,
    this.iconColor = AppColors.info,
  });

  final double borderRadius;
  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return VehicleInfoSurface(
      borderRadius: borderRadius,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 25.sp),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
