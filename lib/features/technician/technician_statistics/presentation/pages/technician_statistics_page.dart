import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/cubit/technician_statistics_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/technician_statistics_body.dart';

class TechnicianStatisticsPage extends StatelessWidget {
  const TechnicianStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(title: strings.statistics, showBackButton: true),
      body: BlocProvider(
        create: (_) => getIt<TechnicianStatisticsCubit>()..getStatistics(),
        child: const ImageBackground(child: TechnicianStatisticsBody()),
      ),
    );
  }
}
