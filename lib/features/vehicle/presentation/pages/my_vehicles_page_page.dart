import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/floating_add_button.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/VehiclesBody.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyVehiclesPagePage extends StatefulWidget {
  const MyVehiclesPagePage({super.key});

  @override
  State<MyVehiclesPagePage> createState() => _MyVehiclesPagePageState();
}

class _MyVehiclesPagePageState extends State<MyVehiclesPagePage> {
  late final VehicleCubit _vehicleCubit;

  @override
  void initState() {
    super.initState();
    _vehicleCubit = getIt<VehicleCubit>()..getAllVehicles();
  }

  @override
  void dispose() {
    _vehicleCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return BlocProvider.value(
      value: _vehicleCubit,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 16.h, left: 16.w),
            child: FloatingAddButton(
              onTap: () async {
                await context.push(Routes.add_vehicle);
                if (mounted) {
                  _vehicleCubit.getAllVehicles();
                }
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          backgroundColor: context.colorScheme.surface,
          appBar: CustomAppBar(
            title: strings.myVehicles,
            onBackTapped: () => context.go(Routes.home),
          ),
          body: const ImageBackground(child: VehiclesBody()),
        ),
      ),
    );
  }
}
