import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/selection/shared_selection_bottom_sheet.dart';
import 'package:car_care/core/widgets/selection/vehicle_selection_tile.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

void showReservationVehiclePicker({
  required BuildContext context,
  required List<VehicleEntity> vehicles,
  required VehicleEntity? selectedVehicle,
  required ValueChanged<VehicleEntity> onSelect,
}) {
  SharedSelectionBottomSheet.show<VehicleEntity>(
    context: context,
    title: context.l10n.selectYourVehicle,
    items: vehicles,
    itemBuilder: (context, v) => VehicleSelectionTile(
      vehicle: v,
      isSelected: selectedVehicle?.id == v.id,
      selectedColor: AppColors.carWashTeal,
    ),
    onSelected: onSelect,
  );
}
