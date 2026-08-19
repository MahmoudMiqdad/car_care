import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/cubit/statistics_cubit.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/cubit/statistics_state.dart';
import 'package:car_care/core/widgets/statistics/ring_card.dart';
import 'package:car_care/core/widgets/statistics/stats_grid.dart';
import 'package:car_care/core/widgets/statistics/stats_rings_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserStatisticsBody extends StatelessWidget {
  const UserStatisticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is StatisticsError) {
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
                    text: l10n.retry, 
                    backgroundColor: AppColors.primary,
                    height: 52.h,
                    borderRadius: 14.r,
                    fontSize: 18.sp,
                    onPressed: () =>
                        context.read<StatisticsCubit>().fetchStatistics(),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is StatisticsLoaded) {
          final d = state.statistics.data;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Column(
              children: [
                StatsRingsRow(
                  cards: [
                    RingCardData(
                      title: l10n.maintenanceRequestsTitle, 
                      headerIcon: Icons.build_outlined,
                      accentColor: AppColors.primary,
                      layout: RingCardLayout.side, 
                      mainValue: d.totalRequests,
                      mainLabel: l10n.invoiceTotal, 
                      progress: d.totalRequests == 0
                          ? 0.0
                          : d.completedRequests / d.totalRequests,
                      indicators: [
                        RingIndicator(
                          label: l10n.bookingStatusCompleted, 
                          value: d.completedRequests,
                          icon: Icons.check_circle_outline,
                          color: AppColors.primary,
                        ),
                        RingIndicator(
                          label: l10n.pending, 
                          value: d.pendingRequests,
                          icon: Icons.hourglass_bottom_outlined,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                StatsGrid(
                  items: [
                    StatTileData(
                      title: l10n.pending, 
                      value: '${d.pendingRequests}',
                      icon: Icons.hourglass_bottom_outlined,
                      color: AppColors.orange,
                    ),
                    StatTileData(
                      title: l10n.totalRequestsLabel, 
                      value: '${d.totalRequests}',
                      icon: Icons.list_alt_outlined,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: l10n.bookingStatusCompleted, 
                      value: '${d.completedRequests}',
                      icon: Icons.check_circle_outline,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: l10n.bookingStatusAccepted, 
                      value: '${d.acceptedRequests}',
                      icon: Icons.verified_outlined,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: l10n.bookingStatusCanceled, 
                      value: '${d.cancelledRequests}',
                      icon: Icons.cancel_outlined,
                      color: AppColors.orange,
                    ),
                  ],
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
