import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/cubit/technician_statistics_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/technician_statistics_body.dart';

class TechnicianStatisticsPage extends StatelessWidget {
  const TechnicianStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(title: strings.statistics, showBackButton: true),
        body: BlocProvider(
          create: (_) => getIt<TechnicianStatisticsCubit>()..getStatistics(),
          child: const ImageBackground(child: TechnicianStatisticsBody()),
        ),
        bottomNavigationBar: HomeBottomNavBar(
          onItemSelected: (index) {
            if (index == 0) context.go(Routes.home);
          },
        ),
      ),
    );
  }
}
