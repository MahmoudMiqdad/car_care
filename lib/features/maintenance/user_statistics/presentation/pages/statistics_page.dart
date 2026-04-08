import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/widgets/statistics_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/cubit/statistics_cubit.dart';

class UserStatisticsPage extends StatelessWidget {
  const UserStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return BlocProvider(
      create: (_) => getIt<StatisticsCubit>()..fetchStatistics(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: CustomAppBar(title: strings.statistics, showBackButton: true),
          body: const ImageBackground(
            child: UserStatisticsBody(),
          ),
          bottomNavigationBar: HomeBottomNavBar(
            onItemSelected: (index) {
              if (index == 0) context.go('/home');
            },
          ),
        ),
      ),
    );
  }
}