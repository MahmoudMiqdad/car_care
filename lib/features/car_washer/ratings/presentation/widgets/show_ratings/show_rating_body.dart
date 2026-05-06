import 'package:car_care/features/car_washer/ratings/presentation/widgets/show_ratings/show_rating_average_section.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/show_ratings/show_rating_comments_section.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/show_ratings/show_rating_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowRatingBody extends StatelessWidget {
  const ShowRatingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: const Column(
        children: [
          ShowRatingSummaryCard(),
          SizedBox(height: 10),
          ShowRatingAverageSection(),
          SizedBox(height: 10),
          ShowRatingCommentsSection(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
