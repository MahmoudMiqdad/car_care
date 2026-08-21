import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/AddVehicleBody.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class AddVehiclePage extends StatelessWidget {
  const AddVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(title: strings.addVehicle),
      body: const ImageBackground(child: AddVehicleBody()),
    );
  }
}
