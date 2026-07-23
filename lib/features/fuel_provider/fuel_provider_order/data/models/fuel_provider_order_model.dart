
class FuelOrderModel {
  final bool? success;
  final String? message;
  final FuelOrderData? data;

  FuelOrderModel({this.success, this.message, this.data});

  factory FuelOrderModel.fromJson(Map<String, dynamic> json) => FuelOrderModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null
            ? FuelOrderData.fromJson(json['data'])
            : null,
      );
}

class FuelOrderListModel {
  final bool? success;
  final List<FuelOrderData> data;

  FuelOrderListModel({this.success, required this.data});

  factory FuelOrderListModel.fromJson(Map<String, dynamic> json) =>
      FuelOrderListModel(
        success: json['success'],
        data: json['data'] != null
            ? List.from(json['data'])
                .map((e) => FuelOrderData.fromJson(e))
                .toList()
            : [],
      );
}

class FuelOrderData {
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
  final FuelOrderVehicleData? vehicle;
  final FuelOrderProviderData? fuelProvider;
  final String? notes;
  final String? createdAt;
  final bool? canCancel;

  FuelOrderData({
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

  factory FuelOrderData.fromJson(Map<String, dynamic> json) => FuelOrderData(
        id: json['id'],
        fuelType: json['fuel_type'],
        amount: double.tryParse(json['amount'].toString()),
        deliveryAddress: json['delivery_address'],
        deliveryLatitude:
            double.tryParse(json['delivery_latitude'].toString()),
        deliveryLongitude:
            double.tryParse(json['delivery_longitude'].toString()),
        totalPrice: json['total_price']?.toString(),
        status: json['status'],
        statusText: json['status_text'],
        scheduledTime: json['scheduled_time'],
        vehicle: json['vehicle'] != null
            ? FuelOrderVehicleData.fromJson(json['vehicle'])
            : null,
        fuelProvider: json['fuel_provider'] != null
            ? FuelOrderProviderData.fromJson(json['fuel_provider'])
            : null,
        notes: json['notes'],
        createdAt: json['created_at'],
        canCancel: json['can_cancel'],
      );
}

class FuelOrderVehicleData {
  final int? id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;
  final String? ownerName;

  FuelOrderVehicleData({
    this.id, this.brand, this.model, this.year,
    this.plateNumber, this.currentKm, this.ownerName,
  });

  factory FuelOrderVehicleData.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>?;
    return FuelOrderVehicleData(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year']?.toString(),
      plateNumber: json['plate_number'],
      currentKm: json['current_km'],
      ownerName: owner?['name'],
    );
  }
}

class FuelOrderProviderData {
  final int? id;
  final String? companyName;
  final String? phone;
  final double? currentLat;
  final double? currentLng;

  FuelOrderProviderData({
    this.id, this.companyName, this.phone,
    this.currentLat, this.currentLng,
  });

  factory FuelOrderProviderData.fromJson(Map<String, dynamic> json) {
    final loc = json['current_location'] as Map<String, dynamic>?;
    return FuelOrderProviderData(
      id: json['id'],
      companyName: json['company_name'],
      phone: json['phone'],
      currentLat: double.tryParse(loc?['lat'].toString() ?? ''),
      currentLng: double.tryParse(loc?['lng'].toString() ?? ''),
    );
  }
}