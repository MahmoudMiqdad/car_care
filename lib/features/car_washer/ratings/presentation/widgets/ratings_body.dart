import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/ratings_comment_field.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/ratings_service_info_card.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/ratings_star_selector.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingsBody extends StatelessWidget {
  const RatingsBody({
    super.key,
    required this.selectedStars,
    required this.commentController,
    required this.onStarsChanged,
    required this.onSubmit,
  });

  final int selectedStars;
  final TextEditingController commentController;
  final ValueChanged<int> onStarsChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 

        children: [
          AppText.sectionTitle(
            strings.ratingsServiceInfoSectionTitle,
            color: AppColors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 8.h),
          const RatingsServiceInfoCard(),
          SizedBox(height: 24.h),
           AppText.sectionTitle(
            strings.ratingsYourRatingQuestion,
            color: AppColors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),

          RatingsStarSelector(
            rating: selectedStars.toDouble(),
            onRatingChanged: onStarsChanged,
            
          ),
          SizedBox(height: 28.h),
          RatingsCommentField(controller: commentController),
          SizedBox(height: 24.h),
          AppButton(
            text: strings.ratingsSendRating,
            onPressed: onSubmit,
            backgroundColor: AppColors.orange,
            borderRadius: 14.r,
            height: 64.h,
            fontSize: 25.sp,
          ),
          SizedBox(height: 96.h),
        ],
      ),
    );
  }
}
