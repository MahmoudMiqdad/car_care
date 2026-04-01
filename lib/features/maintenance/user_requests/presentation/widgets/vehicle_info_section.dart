import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/vehicle_header.dart';
import 'package:car_care/core/widgets/vehicle_info_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleInfoSection extends StatelessWidget {
  const VehicleInfoSection({super.key, required this.cardRadius});

  final double cardRadius;

  @override
  Widget build(BuildContext context) {
    return VehicleHeader(
      imagePath: AppAssets.serviceMyVehicles,
      isNetworkImage: false,
      title: 'سابا سيدان ٢٠٠٣',
      imageSize: 130,
      titleStyle: AppTypography.bodyLarge.copyWith(
        fontWeight: FontWeight.w800,
        color: AppColors.black,
      ),
      spacingBetweenTitleAndBottomChild: 16.h,
      bottomChild: Row(
        children: [
          Expanded(
            child: VehicleInfoPill(
              borderRadius: cardRadius,
              icon: Icons.speed,
              text: '١٢٠,٠٠٠ كم',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: VehicleInfoPill(
              borderRadius: cardRadius,
              imagePath: 'assets/images/number.png', 
              text: '٣٢٨٧٩٧',
            ),
          ),
        ],
      ),
    );
  }
}
