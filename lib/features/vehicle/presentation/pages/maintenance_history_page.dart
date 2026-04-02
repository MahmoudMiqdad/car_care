import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/vehicle/presentation/widgets/maintenance_history/maintenance_history_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MaintenanceHistoryPage extends StatelessWidget {
  const MaintenanceHistoryPage({super.key, required this.vehicleId});
  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: const CustomAppBar(title: 'Maintenance History', showBackButton: true),
        body: ImageBackground(
          child: MaintenanceHistoryBody(vehicleId: vehicleId),
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
