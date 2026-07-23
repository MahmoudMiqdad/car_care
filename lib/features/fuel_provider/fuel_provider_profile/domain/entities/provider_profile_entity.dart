class FuelProviderProfileEntity {
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

  FuelProviderProfileEntity({
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

  final String? status;
  final String? rejectionReason;
}