import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/vehicle/presentation/cubit/maintenance_history/maintenance_history_cubit.dart';
import 'package:car_care/features/vehicle/presentation/widgets/maintenance_history/maintenance_history_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintenanceHistoryPage extends StatelessWidget {
  const MaintenanceHistoryPage({super.key, required this.vehicleId});
  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: strings.maintenanceHistory,
        showBackButton: true,
      ),
      body: ImageBackground(
        child: BlocProvider(
          create: (_) => getIt<MaintenanceHistoryCubit>()..fetch(vehicleId),
          child: MaintenanceHistoryBody(vehicleId: vehicleId),
        ),
      ),
    );
  }
}
