import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/ratings_page/ratings_star_selector.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowRatingAverageSection extends StatelessWidget {
  const ShowRatingAverageSection({super.key});

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
        const RatingsStarSelector(rating: 3.0, onRatingChanged: _ignoreTap),
      ],
    );
  }
}

void _ignoreTap(int _) {}
