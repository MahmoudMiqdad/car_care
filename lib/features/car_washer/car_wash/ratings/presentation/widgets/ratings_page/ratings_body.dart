import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/app_headline.dart'; 
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/widgets/ratings_page/ratings_service_info_card.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/widgets/ratings_page/ratings_star_selector.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingsBody extends StatelessWidget {
  const RatingsBody({
    super.key,
    required this.booking,
    required this.selectedStars,
    required this.onStarsChanged,
    required this.isLoading,
    this.onSubmit,
  });

  final BookingsEntity booking;
  final int selectedStars;
  final ValueChanged<int> onStarsChanged;
  final bool isLoading;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.sectionTitle(
            context,
            strings.ratingsServiceInfoSectionTitle,
            color: AppColors.black,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 8.h),
          RatingsServiceInfoCard(booking: booking),
          SizedBox(height: 24.h),
          AppText.sectionTitle(
            context,
            strings.ratingsYourRatingQuestion,
            color: AppColors.black,
            fontWeight: FontWeight.w900,
          ),
          RatingsStarSelector(
            rating: selectedStars.toDouble(),
            onRatingChanged: onStarsChanged,
          ),
          SizedBox(height: 28.h),
          AppButton(
            text: isLoading ? '...' : strings.ratingsSendRating,
            onPressed: onSubmit,
            backgroundColor: AppColors.orange,
            borderRadius: 14.r,
            height: 54.h,
          ),
          SizedBox(height: 96.h),
        ],
      ),
    );
  }
}
