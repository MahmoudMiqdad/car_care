import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/app_loading_widget.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/VehicleDetailsBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VehicleDetailsPage extends StatelessWidget {
  const VehicleDetailsPage({
    super.key,
    required this.vehicleId,
  });

  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VehicleDetailsCubit>()..fetchVehicleDetails(vehicleId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          appBar: const CustomAppBar(title: 'Vehicle Details'),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppAssets.artboardBackground, fit: BoxFit.cover),
              BlocBuilder<VehicleDetailsCubit, VehicleDetailsState>(
                builder: (context, state) {
                  if (state is VehicleDetailsLoading) {
                    return const Center(child: AppLoadingWidget());
                  }

                  if (state is VehicleDetailsLoaded) {
                    return VehicleDetailsBody(vehicle: state.vehicle);
                  }

                  if (state is VehicleDetailsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          bottomNavigationBar: HomeBottomNavBar(
            onItemSelected: (index) {
              if (index == 0) context.go(Routes.home);
            },
          ),
        ),
      ),
    );
  }
}