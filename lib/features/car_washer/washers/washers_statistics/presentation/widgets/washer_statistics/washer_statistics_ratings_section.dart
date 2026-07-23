import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/widgets/ratings_page/ratings_star_selector.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherStatisticsRatingsSection extends StatelessWidget {
  const WasherStatisticsRatingsSection({
    super.key,
    required this.averageRating,
    required this.ratingsCount,
  });

  final num averageRating;
  final int ratingsCount;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          strings.showRatingAverageRatings,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        AppBoxContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.orange,
                  ),
                ),
                SizedBox(height: 6.h),
                // ✅ الحل: تحديد أقصى عرض + FittedBox لتصغير النجوم تلقائيًا
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RatingsStarSelector(
                      rating: averageRating.toDouble(),
                      onRatingChanged: _ignore,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  strings.profileWasherRatingsCountLine(ratingsCount),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _ignore(int _) {}