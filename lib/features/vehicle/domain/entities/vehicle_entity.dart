class VehicleEntity {
  const VehicleEntity({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.currentKm,
    required this.status,
    required this.needsMaintenance,
    this.image,
    this.imagePath,
    this.ownerId,
    this.ownerName,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String brand;
  final String model;
  final int year;
  final String plateNumber;
  final int currentKm;
  final String status;
  final bool needsMaintenance;
  final String? image;
  final String? imagePath;
  final int? ownerId;
  final String? ownerName;
  final String? createdAt;
  final String? updatedAt;
}