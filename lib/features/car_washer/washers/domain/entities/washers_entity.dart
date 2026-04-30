import 'package:equatable/equatable.dart';

class WasherEntity extends Equatable {
  const WasherEntity({
    required this.id,
    required this.shopName,
    required this.city,
    required this.address,
    required this.logoUrl,
    required this.phone,
    required this.services,
    required this.servicePrices,
    required this.averageRating,
    required this.ratingsCount,
    required this.isAvailable,
    required this.isVerified, required this.openTime, required this.closeTime,
  });

  final int id;
  final String shopName;
  final String city;
  final String address;
  final String? logoUrl;
  final String phone;
  final String openTime;
  final String closeTime;
  final List<String> services;
  final Map<String, int> servicePrices;

  final double averageRating;
  final int ratingsCount;
  final bool isAvailable;
  final bool isVerified;

  String get fullAddress {
    if (city.trim().isEmpty) return address.trim();
    if (address.trim().isEmpty) return city.trim();
    return '${city.trim()} — ${address.trim()}';
  }

  @override
  List<Object?> get props => [
    id,
    shopName,
    city,
    address,
    logoUrl,
    phone,
    services,
    servicePrices,
    averageRating,
    ratingsCount,
    isAvailable,
    isVerified,
  ];
}
