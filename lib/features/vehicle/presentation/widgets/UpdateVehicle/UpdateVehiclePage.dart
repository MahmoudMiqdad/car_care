import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/app_loading_widget.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/update_vehicle_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateVehiclePage extends StatelessWidget {
  final int vehicleId;
  const UpdateVehiclePage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VehicleDetailsCubit>()..fetchVehicleDetails(vehicleId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('تحديث مركبة'), centerTitle: true),
          body: BlocBuilder<VehicleDetailsCubit, VehicleDetailsState>(
            builder: (context, state) {
              if (state is VehicleDetailsLoading) {
                return const Center(child: AppLoadingWidget());
              }
              if (state is VehicleDetailsLoaded) {
                return UpdateVehicleBody(vehicle: state.vehicle);
              }
              if (state is VehicleDetailsError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}