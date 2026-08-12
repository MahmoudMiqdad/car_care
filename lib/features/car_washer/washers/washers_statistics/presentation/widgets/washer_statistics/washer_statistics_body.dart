import 'package:car_care/features/car_washer/washers/washers_statistics/domain/entities/statistics_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/widgets/washer_statistics/washer_statistics_ratings_section.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/widgets/washer_statistics/washer_statistics_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherStatisticsBody extends StatelessWidget {
  const WasherStatisticsBody({super.key, required this.statistics});

  final StatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final bottomSafeSpace = MediaQuery.viewPaddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h + bottomSafeSpace),
      child: Column(
        children: [
          WasherStatisticsSummaryCard(statistics: statistics),
          SizedBox(height: 10.h),
          WasherStatisticsRatingsSection(
            averageRating: statistics.averageRating,
            ratingsCount: statistics.ratingsCount,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
