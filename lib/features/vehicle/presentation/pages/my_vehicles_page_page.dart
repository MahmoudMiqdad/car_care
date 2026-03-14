import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/VehiclesBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyVehiclesPagePage extends StatelessWidget {
  const MyVehiclesPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VehicleCubit>()..getAllVehicles(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          appBar: CustomAppBar(
            title: 'My Vehicles',
            onBackTapped: () => context.go(Routes.home),
            actionWidget: Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.go(Routes.add_vehicle),
                icon: const Icon(
                  Icons.add,
                  color: AppColors.primary,
                  size: 24,
                ),
                splashRadius: 18,
              ),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppAssets.artboardBackground,
                fit: BoxFit.cover,
              ),
              const VehiclesBody(),
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
      ),
    );
  }
}