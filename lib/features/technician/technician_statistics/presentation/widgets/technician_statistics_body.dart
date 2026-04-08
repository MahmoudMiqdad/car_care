import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/statistics/ring_card.dart';
import 'package:car_care/core/widgets/statistics/stats_grid.dart';
import 'package:car_care/core/widgets/statistics/stats_rings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/technician_statistics_cubit.dart';
import '../cubit/technician_statistics_state.dart';
import 'earnings_card.dart';
import 'rating_card.dart';

class TechnicianStatisticsBody extends StatelessWidget {
  const TechnicianStatisticsBody({super.key});

  double _ratio(int part, int total) => total == 0 ? 0.0 : part / total;

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
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 12.h),
                  AppButton(
                    text: 'حاول مرة أخرى',
                    backgroundColor: AppColors.primary,
                    height: 52.h,
                    borderRadius: 14.r,
                    fontSize: 18.sp,
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
                  cards: [
                    RingCardData(
                      title: 'الأعمال',
                      headerIcon: Icons.work_outline,
                      accentColor: AppColors.orange, 
                      mainValue: d.totalJobs,
                      mainLabel: 'الإجمالي',
                      progress: d.totalJobs == 0
                          ? 0.0
                          : d.completedJobs / d.totalJobs,
                      indicators: [
                        RingIndicator(
                          label: 'المكتملة',
                          value: d.completedJobs,
                          icon: Icons.check_circle_outline,
                          color: AppColors.orange,
                        ),
                      ],
                    ),
                    RingCardData(
                      title: 'العروض',
                      headerIcon: Icons.description_outlined,
                      accentColor: AppColors.primary, 
                      mainValue: d.totalQuotations,
                      mainLabel: 'الإجمالي',
                      progress: d.totalQuotations == 0
                          ? 0.0
                          : d.acceptedQuotations / d.totalQuotations,
                      indicators: [
                        RingIndicator(
                          label: 'المقبولة',
                          value: d.acceptedQuotations,
                          icon: Icons.verified_outlined,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                StatsGrid(
                  items: [
                    StatTileData(
                      title: 'المعينة',
                      value: '${d.assignedJobs}',
                      icon: Icons.assignment_ind_outlined,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: 'قيد التنفيذ',
                      value: '${d.inProgressJobs}',
                      icon: Icons.timelapse_outlined,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: 'العروض المعلقة',
                      value: '${d.pendingQuotations}',
                      icon: Icons.hourglass_top_outlined,
                      color: AppColors.orange,
                    ),
                    StatTileData(
                      title: 'المكتملة',
                      value: '${d.completedJobs}',
                      icon: Icons.check_circle_outline,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: 'عدد التقييمات',
                      value: '${d.totalRatings}',
                      icon: Icons.star_border_rounded,
                      color: AppColors.orange,
                    ),
                    StatTileData(
                      title: 'العروض المقبولة',
                      value: '${d.acceptedQuotations}',
                      icon: Icons.verified_outlined,
                      color: AppColors.orange,
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
                EarningsCard(totalEarnings: d.totalEarnings),
                SizedBox(height: 16.h),
                RatingCard(
                  averageRating: d.averageRating,
                  totalRatings: d.totalRatings,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
