import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_avatar.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_page/washer_star_rating_row.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_page/washer_tier_badges.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherListingCard extends StatelessWidget {
  const WasherListingCard({
    super.key,
    required this.washer,
    this.onBook,
    this.onDetails,
  });

  final WasherEntity washer;
  final ValueChanged<WasherEntity>? onBook;
  final ValueChanged<WasherEntity>? onDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: InkWell(
        onTap: () => HapticFeedback.selectionClick(),
        borderRadius: BorderRadius.circular(14.r),
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: WasherTierBadges(servicePrices: washer.servicePrices),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          washer.shopName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          l10n.washersCityWithName(washer.city),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.lightTextSecondary,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l10n.washersRatingsWithCount(washer.ratingsCount),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.lightTextSecondary,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        WasherStarRatingRow(rating: washer.averageRating),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  WasherAvatar(logoUrl: washer.logoUrl),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SoftOutlinedButton(
                      label: l10n.washersViewDetails,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onDetails?.call(washer);
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _SoftOutlinedButton(
                      label: l10n.washersBookAppointment,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onBook?.call(washer);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoftOutlinedButton extends StatelessWidget {
  const _SoftOutlinedButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        minimumSize: Size(0, 44.h),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.r),
        ),
        backgroundColor: AppColors.white,
        overlayColor: AppColors.primary.withValues(alpha: 0.1),
        splashFactory: InkRipple.splashFactory,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}