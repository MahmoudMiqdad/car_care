// ignore_for_file: file_names
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/update_vehicle_body.dart';
import 'package:flutter/material.dart';

class UpdateVehiclePage extends StatelessWidget {
  final VehicleEntity vehicle;

  const UpdateVehiclePage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppBar(
          title: const Text('تحديث مركبة'),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.artboardBackground,
              fit: BoxFit.cover,
            ),
            UpdateVehicleBody(vehicle: vehicle),
          ],
        ),)
      ,
    );
  }
}
