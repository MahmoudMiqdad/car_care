class FuelProviderProfileModel {
  final bool? success;
  final String? message;
  final FuelProviderProfileData? data;

  FuelProviderProfileModel({this.success, this.message, this.data});

  factory FuelProviderProfileModel.fromJson(Map<String, dynamic> json) =>
      FuelProviderProfileModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null
            ? FuelProviderProfileData.fromJson(json['data'])
            : null,
      );
}

class FuelProviderProfileData {
  final int? id;
  final String? companyName;
  final String? phone;
  final String? city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final List<String>? fuelTypes;
  final Map<String, double>? prices;
  final bool? isAvailable;
  final bool? isVerified;
  final String? createdAt;
  final String? status;
  final String? rejectionReason;

  FuelProviderProfileData({
    this.id,
    this.companyName,
    this.phone,
    this.city,
    this.address,
    this.latitude,
    this.longitude,
    this.fuelTypes,
    this.prices,
    this.isAvailable,
    this.isVerified,
    this.createdAt,
    this.status,
    this.rejectionReason,
  });

  factory FuelProviderProfileData.fromJson(Map<String, dynamic> json) =>
      FuelProviderProfileData(
        id: json['id'],
        companyName: json['company_name'],
        phone: json['phone'],
        city: json['city'],
        address: json['address'],
        latitude: double.tryParse(json['latitude'].toString()),
        longitude: double.tryParse(json['longitude'].toString()),
        fuelTypes: json['fuel_types'] != null
            ? List<String>.from(json['fuel_types'])
            : null,
        prices: json['prices'] != null
            ? Map<String, double>.fromEntries(
                (json['prices'] as Map<String, dynamic>).entries.map(
                      (e) => MapEntry(
                          e.key, double.tryParse(e.value.toString()) ?? 0),
                    ),
              )
            : null,
        isAvailable: json['is_available'],
        isVerified: json['is_verified'],
        createdAt: json['created_at'],
        status: json['status'] as String?,
        rejectionReason: json['rejection_reason'] as String?,
      );
}