import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationHeaderInfo extends StatelessWidget {
  const ReservationHeaderInfo({super.key, required this.listing});

  final CarWashListing listing;

  @override
  Widget build(BuildContext context) {
    final locationText =
        listing.fullAddress.isNotEmpty ? listing.fullAddress : listing.cityName;

    return Column(
      children: <Widget>[
        Center(
          child: WasherAvatar(
            listing: listing,
            diameter: 100,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          listing.name,
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w800,
            fontSize: 22.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          locationText,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
