import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/AddVehicleBody.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddVehiclePage extends StatelessWidget {
  const AddVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: const CustomAppBar(
          title: 'Add Vehicles',
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.artboardBackground,
              fit: BoxFit.cover,
            ),
            const AddVehicleBody(),
          ],
        ),
        bottomNavigationBar: HomeBottomNavBar(
          onItemSelected: (index) {
            if (index == 0) {
              context.go(Routes.home);
            }
          },
        ),
      ),
    );
  }
}



