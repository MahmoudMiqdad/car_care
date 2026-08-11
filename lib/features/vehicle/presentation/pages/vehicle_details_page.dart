import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/VehicleDetailsBody.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleDetailsPage extends StatelessWidget {
  const VehicleDetailsPage({super.key, required this.vehicleId});
  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return BlocProvider(
      create: (_) =>
          getIt<VehicleDetailsCubit>()..fetchVehicleDetails(vehicleId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          appBar: CustomAppBar(title: strings.vehicleDetails),
          body: ImageBackground(
            child: BlocBuilder<VehicleDetailsCubit, VehicleDetailsState>(
              builder: (context, state) {
                if (state is VehicleDetailsLoading) {
                  return const Center(child: AppLoadingWidget());
                }
                if (state is VehicleDetailsLoaded) {
                  return VehicleDetailsBody(vehicle: state.vehicle);
                }
                if (state is VehicleDetailsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: context.textTheme.titleMedium,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
