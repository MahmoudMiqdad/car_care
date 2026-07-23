import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/cubit/provider_statistics_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/cubit/provider_statistics_state.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/widgets/provider_statistics/provider_statistics_orders_card.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/widgets/provider_statistics/provider_statistics_profits_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderStatisticsBody extends StatelessWidget {
  const ProviderStatisticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FuelProviderStatisticsCubit, FuelProviderStatisticsState>(
      builder: (context, state) {
        if (state is FuelProviderStatisticsLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is FuelProviderStatisticsError) {
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
                        .read<FuelProviderStatisticsCubit>()
                        .getStatistics(),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is FuelProviderStatisticsLoaded) {
          final stats = state.statistics;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProviderStatisticsOrdersCard(statistics: stats),
                SizedBox(height: 16.h),
                ProviderStatisticsProfitsCard(statistics: stats),
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