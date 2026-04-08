import 'package:car_care/features/maintenance/user_requests/data/models/user_model.dart';
import 'package:car_care/features/technician/technician_profile/data/models/technician_profile.dart';

class VehicleModel {
  final int? id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;
  final String? image;
  final String? imagePath;
  final UserModel? owner;
  final String? status;
  final bool? needsMaintenance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VehicleModel({
    this.id,
    this.brand,
    this.model,
    this.year,
    this.plateNumber,
    this.currentKm,
    this.image,
    this.imagePath,
    this.owner,
    this.status,
    this.needsMaintenance,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VehicleModel();

    return VehicleModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      plateNumber: json['plate_number'],
      currentKm: json['current_km'],
      image: json['image'],
      imagePath: json['image_path'],
      owner: json['owner'] != null ? UserModel.fromJson(json['owner']) : null,
      status: json['status'],
      needsMaintenance: json['needs_maintenance'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}