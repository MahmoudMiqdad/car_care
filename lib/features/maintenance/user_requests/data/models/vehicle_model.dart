import 'package:car_care/features/technician/technician_profile/data/models/technician_profile.dart';

class VehicleModel {
  final int id;
  final String brand;
  final String model;
  final String year;
  final String plateNumber;
  final int currentKm;
  final String? image;
  final String? imagePath;
  final User owner;
  final String status;
  final bool needsMaintenance;
final DateTime createdAt;
final DateTime updatedAt;

  VehicleModel({
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

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      plateNumber: json['plate_number'],
      currentKm: json['current_km'],
      image: json['image'],
      imagePath: json['image_path'],
      owner: User.fromJson(json['owner']),
      status: json['status'],
      needsMaintenance: json['needs_maintenance'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }


}