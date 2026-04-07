import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/cubit/technician_statistics_cubit.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/cubit/technician_statistics_state.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/widgets/stats_rings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'earnings_card.dart';
import 'rating_card.dart';

class TechnicianStatisticsBody extends StatelessWidget {
  const TechnicianStatisticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechnicianStatisticsCubit, TechnicianStatisticsState>(
      builder: (context, state) {
        if (state is TechnicianStatisticsLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is TechnicianStatisticsError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.message.isNotEmpty
                        ? state.message
                        : 'حدث خطأ غير متوقع',
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 14.h),
                  AppButton(
                    text: 'حاول مرة أخرى',
                    backgroundColor: AppColors.primary,
                    height: 50.h,
                    borderRadius: 14.r,
                    onPressed: () => context
                        .read<TechnicianStatisticsCubit>()
                        .getStatistics(),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TechnicianStatisticsLoaded) {
          final d = state.data.data;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Column(
              children: [
                StatsRingsRow(
                  // quotations ring
                  quotationsTotal: d.totalQuotations,
                  quotationsAccepted: d.acceptedQuotations,
                  quotationsPending: d.pendingQuotations,

                  // jobs ring
                  jobsTotal: d.totalJobs,
                  jobsCompleted: d.completedJobs,
                  jobsInProgress: d.inProgressJobs,
                ),
                SizedBox(height: 14.h),
                EarningsCard(totalEarnings: d.totalEarnings),
                SizedBox(height: 14.h),
                RatingCard(
                  averageRating: d.averageRating,
                  totalRatings: d.totalRatings,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
