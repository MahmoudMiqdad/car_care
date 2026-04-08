import 'package:car_care/features/maintenance/user_requests/domain/entities/user_entity.dart';

import '../entities/vehicle_entity.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/vehicle_model.dart';
import 'user_mapper.dart';

extension VehicleMapper on VehicleModel {
  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id ?? 0,
      brand: brand ?? '',
      model: model ?? '',
      year: year ?? '',
      plateNumber: plateNumber ?? '',
      currentKm: currentKm ?? 0,
      image: image,
      imagePath: imagePath,
      owner: owner?.toEntity() ?? UserEntity(id: 0, name: ''),
      status: status ?? '',
      needsMaintenance: needsMaintenance ?? false,
      createdAt: createdAt != null
          ? DateTime.tryParse(createdAt.toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: updatedAt != null
          ? DateTime.tryParse(updatedAt.toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}