import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/technician_statistics_cubit.dart';
import '../cubit/technician_statistics_state.dart';
import 'earnings_card.dart';
import 'rating_card.dart';
import 'technician_indicators_card.dart';
import 'technician_jobs_summary_card.dart';
import 'technician_quotations_summary_card.dart';

class TechnicianStatisticsBody extends StatelessWidget {
  const TechnicianStatisticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                    text: l10n.retry,
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
          final bottomSafeSpace = MediaQuery.viewPaddingOf(context).bottom;

          return SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20.w,
                20.h,
                20.w,
                20.h + bottomSafeSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TechnicianJobsSummaryCard(data: d),
                  SizedBox(height: 12.h),
                  TechnicianQuotationsSummaryCard(data: d),
                  SizedBox(height: 12.h),
                  TechnicianIndicatorsCard(data: d),
                  SizedBox(height: 12.h),
                  EarningsCard(totalEarnings: d.totalEarnings),
                  SizedBox(height: 12.h),
                  RatingCard(
                    averageRating: d.averageRating,
                    totalRatings: d.totalRatings,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
