import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  const VehicleModel({
    required super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.plateNumber,
    required super.currentKm,
    required super.status,
    required super.needsMaintenance,
    super.image,
    super.imagePath,
    super.ownerId,
    super.ownerName,
    super.createdAt,
    super.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>?;

    return VehicleModel(
      id: _toInt(json['id']),
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      year: _toInt(json['year']),
      plateNumber: json['plate_number']?.toString() ?? '',
      currentKm: _toInt(json['current_km']),
      image: json['image']?.toString(),
      imagePath: json['image_path']?.toString(),
      ownerId: _toNullableInt(owner?['id']),
      ownerName: owner?['name']?.toString(),
      status: json['status']?.toString() ?? '',
      needsMaintenance: json['needs_maintenance'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'plate_number': plateNumber,
      'current_km': currentKm,
      'image': image,
      'image_path': imagePath,
      'owner': {
        'id': ownerId,
        'name': ownerName,
      },
      'status': status,
      'needs_maintenance': needsMaintenance,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}