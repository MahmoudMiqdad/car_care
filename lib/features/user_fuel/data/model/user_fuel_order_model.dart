class UserFuelOrderModel {
  final bool? success;
  final String? message;
  final UserFuelOrderData? data;

  UserFuelOrderModel({this.success, this.message, this.data});

  factory UserFuelOrderModel.fromJson(Map<String, dynamic> json) =>
      UserFuelOrderModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null
            ? UserFuelOrderData.fromJson(json['data'])
            : null,
      );
}

class UserFuelOrderListModel {
  final bool? success;
  final List<UserFuelOrderData> data;

  UserFuelOrderListModel({this.success, required this.data});

  factory UserFuelOrderListModel.fromJson(Map<String, dynamic> json) =>
      UserFuelOrderListModel(
        success: json['success'],
        data: json['data'] != null
            ? List.from(
                json['data'],
              ).map((e) => UserFuelOrderData.fromJson(e)).toList()
            : [],
      );
}

class UserFuelOrderData {
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
  final UserFuelOrderVehicleData? vehicle;
  final UserFuelOrderProviderData? fuelProvider;
  final String? notes;
  final String? createdAt;
  final bool? canCancel;

  UserFuelOrderData({
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

  factory UserFuelOrderData.fromJson(Map<String, dynamic> json) =>
      UserFuelOrderData(
        id: json['id'],
        fuelType: json['fuel_type'],
        amount: double.tryParse(json['amount'].toString()),
        deliveryAddress: json['delivery_address'],
        deliveryLatitude: double.tryParse(json['delivery_latitude'].toString()),
        deliveryLongitude: double.tryParse(
          json['delivery_longitude'].toString(),
        ),
        totalPrice: json['total_price']?.toString(),
        status: json['status'],
        statusText: json['status_text'],
        scheduledTime: json['scheduled_time'],
        vehicle: json['vehicle'] != null
            ? UserFuelOrderVehicleData.fromJson(json['vehicle'])
            : null,
        fuelProvider: json['fuel_provider'] != null
            ? UserFuelOrderProviderData.fromJson(json['fuel_provider'])
            : null,
        notes: json['notes'],
        createdAt: json['created_at'],
        canCancel: json['can_cancel'],
      );
}

class UserFuelOrderVehicleData {
  final int? id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;
  final String? ownerName;
  final String? image;
  final String? imagePath;

  UserFuelOrderVehicleData({
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

  factory UserFuelOrderVehicleData.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>?;
    return UserFuelOrderVehicleData(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year']?.toString(),
      plateNumber: json['plate_number'],
      currentKm: json['current_km'],
      ownerName: owner?['name'],
      // Same "vehicle" resource shape as the maintenance-request flow
      // (see vehicle_model.dart), just not read here before.
      image: json['image']?.toString(),
      imagePath: json['image_path']?.toString(),
    );
  }
}

class UserFuelOrderProviderData {
  final int? id;
  final String? companyName;
  final String? phone;
  final double? currentLat;
  final double? currentLng;

  UserFuelOrderProviderData({
    this.id,
    this.companyName,
    this.phone,
    this.currentLat,
    this.currentLng,
  });

  factory UserFuelOrderProviderData.fromJson(Map<String, dynamic> json) {
    final loc = json['current_location'] as Map<String, dynamic>?;
    return UserFuelOrderProviderData(
      id: json['id'],
      companyName: json['company_name'],
      phone: json['phone'],
      currentLat: double.tryParse(loc?['lat'].toString() ?? ''),
      currentLng: double.tryParse(loc?['lng'].toString() ?? ''),
    );
  }
}
