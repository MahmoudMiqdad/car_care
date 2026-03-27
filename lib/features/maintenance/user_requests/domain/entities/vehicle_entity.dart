// domain/entities/vehicle_entity.dart
import 'package:car_care/features/technician/technician_profile/domain/entities/technician_profile_entity.dart';


class VehicleEntity {
  final int id;
  final String brand;
  final String model;
  final String year;
  final String plateNumber;
  final int currentKm;
  final String? image;
  final String? imagePath;
  final UserEntity owner;
  final String status;
  final bool needsMaintenance;
  final DateTime createdAt;
final DateTime updatedAt;

  VehicleEntity({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.currentKm,
    this.image,
    this.imagePath,
    required this.owner,
    required this.status,
    required this.needsMaintenance,
    required this.createdAt,
    required this.updatedAt,
  });
}