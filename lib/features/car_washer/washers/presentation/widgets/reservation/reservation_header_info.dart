import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationHeaderInfo extends StatelessWidget {
  const ReservationHeaderInfo({super.key, required this.washer});

  final WasherEntity washer;

  @override
  Widget build(BuildContext context) {
    final locationText = washer.fullAddress.isNotEmpty
        ? washer.fullAddress
        : washer.city;

    return Column(
      children: <Widget>[
        Center(
          child: WasherAvatar(
            logoUrl: washer.logoUrl,
            diameter: 100,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          washer.shopName,
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