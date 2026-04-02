// ignore_for_file: file_names
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/widgets/vehicle_info_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Labeled metric card (title + icon/value row) — surface matches [VehicleInfoSurface].
class VehicleInfoCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  const VehicleInfoCardWidget({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return VehicleInfoSurface(
      borderRadius: 16.r,
      padding: EdgeInsets.all(8.w),
      shadowBlur: AppConstants.vehicleInfoLabeledCardShadowBlur,
      shadowOpacity: 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                            SizedBox(width: 10,),

              icon,
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
                            SizedBox(width: 12,),

            ],
          ),
        ],
      ),
    );
  }
}
