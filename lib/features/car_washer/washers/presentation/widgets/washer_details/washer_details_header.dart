import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_avatar.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_page/washer_star_rating_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherDetailsHeader extends StatelessWidget {
  const WasherDetailsHeader({super.key, required this.listing});

  final CarWashListing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        WasherAvatar(listing: listing, diameter: 120),
        SizedBox(width: 4.w),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              listing.name,
              textAlign: TextAlign.right,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 4.h),
            WasherStarRatingRow(rating: listing.stars),
            SizedBox(height: 2.h),
            Text(
              l10n.washersRatingsWithCount(listing.ratingsCount),
              textAlign: TextAlign.right,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.lightTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
