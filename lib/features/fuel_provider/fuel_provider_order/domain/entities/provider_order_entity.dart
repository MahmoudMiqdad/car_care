class FuelOrderEntity {
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
  final FuelOrderVehicleEntity? vehicle;
  final FuelOrderProviderEntity? fuelProvider;
  final String? notes;
  final String? createdAt;
  final bool? canCancel;

  FuelOrderEntity({
    this.id, this.fuelType, this.amount,
    this.deliveryAddress, this.deliveryLatitude, this.deliveryLongitude,
    this.totalPrice, this.status, this.statusText, this.scheduledTime,
    this.vehicle, this.fuelProvider, this.notes, this.createdAt, this.canCancel,
  });
}

class FuelOrderVehicleEntity {
  final int? id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;
  final String? ownerName;

  FuelOrderVehicleEntity({
    this.id, this.brand, this.model, this.year,
    this.plateNumber, this.currentKm, this.ownerName,
  });
}

class FuelOrderProviderEntity {
  final int? id;
  final String? companyName;
  final String? phone;
  final double? currentLat;
  final double? currentLng;

  FuelOrderProviderEntity({
    this.id, this.companyName, this.phone,
    this.currentLat, this.currentLng,
  });
}