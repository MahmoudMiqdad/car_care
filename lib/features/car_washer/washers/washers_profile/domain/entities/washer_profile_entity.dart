import 'package:equatable/equatable.dart';

class WasherProfileEntity extends Equatable {
  const WasherProfileEntity({
    required this.id,
    required this.shopName,
    required this.phone,
    required this.city,
    required this.address,
    required this.description,
    required this.logoUrl,
    required this.services,
    required this.servicePrices,
    required this.workingHours,
    required this.isAvailable,
    required this.isVerified,
    required this.averageRating,
    required this.ratingsCount,
    required this.ratingStars,
    required this.createdAt,
    this.status,
    this.rejectionReason,
  });

  final int id;
  final String shopName;
  final String phone;
  final String city;
  final String address;
  final String description;

  final String? logoUrl;

  final List<String> services; 
  final Map<String, int> servicePrices; 
  final Map<String, String>
  workingHours;

  final bool isAvailable;
  final bool isVerified;
  final num averageRating;
  final int ratingsCount;
  final String ratingStars;
  final String createdAt;
  final String? status;
  final String? rejectionReason;

  @override
  List<Object?> get props => [id, shopName, phone, city, address, createdAt];
}
