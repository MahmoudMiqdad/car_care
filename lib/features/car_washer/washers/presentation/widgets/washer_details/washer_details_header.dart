import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_avatar.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_page/washer_star_rating_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherDetailsHeader extends StatelessWidget {
  const WasherDetailsHeader({super.key, required this.washer});

  final WasherEntity washer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        WasherAvatar(
          logoUrl: washer.logoUrl,
          diameter: 120,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                washer.shopName,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 6.h),
              WasherStarRatingRow(rating: washer.averageRating),
              SizedBox(height: 4.h),
              Text(
                l10n.washersRatingsWithCount(washer.ratingsCount),
                textAlign: TextAlign.right,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}