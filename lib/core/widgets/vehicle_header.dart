// ignore_for_file: deprecated_member_use

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/vehicle_image_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleHeader extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final String title;
  final TextStyle? titleStyle;
  final Widget? bottomChild;
  final double imageHeight;

  const VehicleHeader({
    super.key,
    required this.imagePath,
    this.isNetworkImage = true,
    required this.title,
    this.titleStyle,
    this.bottomChild,
    this.imageHeight = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          VehicleImageBox(imageUrl: imagePath.isEmpty ? null : imagePath),

          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                titleStyle ??
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color:AppColors.textPrimary(context),
                  letterSpacing: 0.5,
                ),
          ),

          if (bottomChild != null) ...[bottomChild!],
        ],
      ),
    );
  }
}
