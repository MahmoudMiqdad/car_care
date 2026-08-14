class UserFuelOrderEntity {
  final int? id;
  final String? fuelType;
  final double? amount;
  final String? deliveryAddress;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? totalPrice;
  final String? status;
  final String? statusText;
  final String? scheduledTime;
  final UserFuelOrderVehicleEntity? vehicle;
  final UserFuelOrderProviderEntity? fuelProvider;
  final String? notes;
  final String? createdAt;
  final bool? canCancel;

  UserFuelOrderEntity({
    this.id,
    this.fuelType,
    this.amount,
    this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.totalPrice,
    this.status,
    this.statusText,
    this.scheduledTime,
    this.vehicle,
    this.fuelProvider,
    this.notes,
    this.createdAt,
    this.canCancel,
  });
}

class UserFuelOrderVehicleEntity {
  final int? id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;
  final String? ownerName;

  /// Raw `image` / `image_path` from the API; resolve with resolveMediaUrl().
  final String? image;
  final String? imagePath;

  UserFuelOrderVehicleEntity({
    this.id,
    this.brand,
    this.model,
    this.year,
    this.plateNumber,
    this.currentKm,
    this.ownerName,
    this.image,
    this.imagePath,
  });
}

class UserFuelOrderProviderEntity {
  final int? id;
  final String? companyName;
  final String? phone;
  final double? currentLat;
  final double? currentLng;

  UserFuelOrderProviderEntity({
    this.id,
    this.companyName,
    this.phone,
    this.currentLat,
    this.currentLng,
  });
}
