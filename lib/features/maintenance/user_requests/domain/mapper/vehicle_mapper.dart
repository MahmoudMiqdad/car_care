// data/models/vehicle_model.dart
import 'package:car_care/features/maintenance/user_requests/data/models/vehicle_model.dart';

import '../entities/vehicle_entity.dart';

extension VehicleMapper on VehicleModel {
  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      brand: brand,
      model: model,
      year: year,
      plateNumber: plateNumber,
      currentKm: currentKm,
      image: image,
      imagePath: imagePath,
      owner: owner.toEntity(),
      status: status,
      needsMaintenance: needsMaintenance,
      createdAt: DateTime.parse(createdAt as String),
      updatedAt: DateTime.parse(updatedAt as String),
    );
  }
}