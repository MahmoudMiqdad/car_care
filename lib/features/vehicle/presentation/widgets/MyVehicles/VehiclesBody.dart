// ignore_for_file: file_names

import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/VehiclesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehiclesBody extends StatelessWidget {
  const VehiclesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<VehicleCubit>().getAllVehicles(),
            child: switch (state) {
              VehicleLoading() => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 120.h),
                  const Center(child: AppLoadingWidget()),
                ],
              ),
              VehicleError(:final message) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 120.h),
                  Center(child: Text(message)),
                ],
              ),
              VehicleEmpty() => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 120.h),
                  Center(child: EmptyStateWidget()),
                ],
              ),
              VehicleLoaded(:final vehicles) => VehiclesList(items: vehicles),
              _ => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [SizedBox.shrink()],
              ),
            },
          );
        },
      ),
    );
  }
}
