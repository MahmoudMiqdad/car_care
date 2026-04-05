import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/RefreshHint.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/VehiclesList.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehiclesBody extends StatelessWidget {
  const VehiclesBody({super.key});

  @override
  Widget build(BuildContext context) {
      final strings = context.l10n;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RefreshHint(
            hintText: strings.updateCarsList,
            onTap: () => context.read<VehicleCubit>().getAllVehicles(),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocBuilder<VehicleCubit, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading) {
                  return const Center(child: AppLoadingWidget());
                }
                if (state is VehicleError) {
                  return Center(child: Text(state.message));
                }
                if (state is VehicleEmpty) {
                  return  Center(child: Text(strings.noCarsYet));
                }
                if (state is VehicleLoaded) {
                  return VehiclesList(items: state.vehicles);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}