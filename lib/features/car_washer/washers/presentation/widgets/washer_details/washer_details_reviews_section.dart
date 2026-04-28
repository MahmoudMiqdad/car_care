import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/washers/domain/car_wash_customer_review.dart';
import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_page/washer_star_rating_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class WasherDetailsReviewsSection extends StatelessWidget {
  const WasherDetailsReviewsSection({super.key, required this.listing});

  final CarWashListing listing;

  @override
  Widget build(BuildContext context) {
    if (listing.reviews.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText.sectionTitle(
          context.l10n.washerSectionCustomerReviews,
          color: AppColors.lightTextPrimary,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 2.h),
        for (var i = 0; i < listing.reviews.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: 10.h),
          ReviewCard(review: listing.reviews[i]),
        ],
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final CarWashCustomerReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ReviewDate(date: review.date),
          ReviewerRow(
            authorName: review.authorName,
            imagePath: AppAssets.reviewerProfilePicture100,
          ),
          ReviewComment(comment: review.comment),
          WasherStarRatingRow(
            rating: review.stars,
            iconSize: 18.sp,
          ),
        ],
      ),
    );
  }
}

class ReviewDate extends StatelessWidget {
  const ReviewDate({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final dateText = intl.DateFormat('d/M/yyyy', locale.languageCode).format(date);

    return Align(
      alignment: Alignment.centerRight,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          dateText,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.lightTextSecondary,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}

class ReviewerRow extends StatelessWidget {
  const ReviewerRow({super.key, required this.authorName, required this.imagePath});

  final String authorName;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.lightSurface,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            authorName,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.black,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewComment extends StatelessWidget {
  const ReviewComment({super.key, required this.comment});

  final String comment;

  @override
  Widget build(BuildContext context) {
    return Text(
      comment,
      textAlign: TextAlign.right,
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
