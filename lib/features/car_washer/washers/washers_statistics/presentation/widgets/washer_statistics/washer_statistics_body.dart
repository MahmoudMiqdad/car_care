import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_state.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/domain/entities/statistics_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/widgets/washer_statistics/washer_statistics_indicators_card.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/widgets/washer_statistics/washer_statistics_summary_card.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/widgets/car_washer_ratings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherStatisticsBody extends StatelessWidget {
  const WasherStatisticsBody({super.key, required this.statistics});

  final StatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final bottomSafeSpace = MediaQuery.viewPaddingOf(context).bottom;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h + bottomSafeSpace),
        child: Column(
          children: [
            WasherStatisticsSummaryCard(statistics: statistics),
            SizedBox(height: 12.h),
            WasherStatisticsIndicatorsCard(statistics: statistics),
            SizedBox(height: 12.h),
            const _StatisticsRatingsSlot(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _StatisticsRatingsSlot extends StatelessWidget {
  const _StatisticsRatingsSlot();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileWasherCubit, ProfileWasherState>(
      builder: (context, state) {
        if (state is ProfileWasherLoaded) {
          return CarWasherRatingsSection(carWasherId: state.profile.id);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
