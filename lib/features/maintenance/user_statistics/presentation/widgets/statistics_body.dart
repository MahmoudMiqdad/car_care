import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/cubit/statistics_cubit.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/cubit/statistics_state.dart';
import 'package:car_care/core/widgets/statistics/ring_card.dart';
import 'package:car_care/core/widgets/statistics/stats_grid.dart';
import 'package:car_care/core/widgets/statistics/stats_rings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserStatisticsBody extends StatelessWidget {
  const UserStatisticsBody({super.key});

  double _ratio(int part, int total) => total == 0 ? 0.0 : part / total;

  @override
  Widget build(BuildContext context) {
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
                    text: 'حاول مرة أخرى',
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
                      title: 'طلبات الصيانة',
                      headerIcon: Icons.build_outlined,
                      accentColor: AppColors.primary,
                      layout: RingCardLayout
                          .side, // ✅ نفس شكل الديزاينر (مؤشرات بجانب الدائرة)
                      mainValue: d.totalRequests,
                      mainLabel: 'الإجمالي',
                      progress: d.totalRequests == 0
                          ? 0.0
                          : d.completedRequests / d.totalRequests,
                      indicators: [
                        RingIndicator(
                          label: 'المكتملة',
                          value: d.completedRequests,
                          icon: Icons.check_circle_outline,
                          color: AppColors.primary,
                        ),
                        RingIndicator(
                          label: 'قيد الانتظار',
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
                      title: 'قيد الانتظار',
                      value: '${d.pendingRequests}',
                      icon: Icons.hourglass_bottom_outlined,
                      color: AppColors.orange,
                    ),
                    StatTileData(
                      title: 'إجمالي الطلبات',
                      value: '${d.totalRequests}',
                      icon: Icons.list_alt_outlined,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: 'المكتملة',
                      value: '${d.completedRequests}',
                      icon: Icons.check_circle_outline,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: 'المقبولة',
                      value: '${d.acceptedRequests}',
                      icon: Icons.verified_outlined,
                      color: AppColors.primary,
                    ),
                    StatTileData(
                      title: 'الملغاة',
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
