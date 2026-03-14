// ignore_for_file: file_names

import 'package:car_care/core/widgets/app_loading_widget.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/RefreshHint.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/VehiclesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehiclesBody extends StatelessWidget {
  const VehiclesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        top: 16.h,
        bottom: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.h),
          RefreshHint(
            onTap: () {
              context.read<VehicleCubit>().getAllVehicles();
            },
          ),
          SizedBox(height: 27.h),
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
                  return const Center(child: Text('لا توجد سيارات حتى الآن'));
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
