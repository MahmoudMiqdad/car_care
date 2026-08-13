import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_circle_avatar.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/entities/washer_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWasherHeader extends StatelessWidget {
  const ProfileWasherHeader({super.key, required this.profile});

  final WasherProfileEntity profile;

  static const double _avatarDiameter = 132;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: _avatarDiameter.r,
          height: _avatarDiameter.r,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              AppCircleAvatar(
                diameter: _avatarDiameter,
                networkImageUrl: profile.logoUrl ?? '',
                placeholderAssetPath: AppAssets.washersPatternBackground,
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          profile.shopName,
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
            fontSize: 27.sp,
          ),
        ),
      ],
    );
  }
}
