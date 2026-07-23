import '../../domain/entities/washer_profile_entity.dart';

class WasherProfileModel extends WasherProfileEntity {
  const WasherProfileModel({
    required super.id,
    required super.shopName,
    required super.phone,
    required super.city,
    required super.address,
    required super.description,
    required super.logoUrl,
    required super.services,
    required super.servicePrices,
    required super.workingHours,
    required super.isAvailable,
    required super.isVerified,
    required super.averageRating,
    required super.ratingsCount,
    required super.ratingStars,
    required super.createdAt,
    super.status,
    super.rejectionReason,
  });

  factory WasherProfileModel.fromJson(Map<String, dynamic> json) {
    return WasherProfileModel(
      id: _toInt(json['id']),
      shopName: (json['shop_name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      logoUrl: json['logo']?.toString(),

      services: _toStringList(json['services']),
      servicePrices: _toIntMap(json['service_prices']),
      workingHours: _toStringMap(json['working_hours']),

      isAvailable: json['is_available'] == true,
      isVerified: json['is_verified'] == true,
      averageRating: (json['average_rating'] is num)
          ? (json['average_rating'] as num)
          : num.tryParse((json['average_rating'] ?? '0').toString()) ?? 0,
      ratingsCount: _toInt(json['ratings_count']),
      ratingStars: (json['rating_stars'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      status: json['status']?.toString(),
      rejectionReason: json['rejection_reason']?.toString(),
    );
  }

  static int _toInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static List<String> _toStringList(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    return <String>[];
  }

  static Map<String, int> _toIntMap(dynamic v) {
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), _toInt(val)));
    }
    return <String, int>{};
  }

  static Map<String, String> _toStringMap(dynamic v) {
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), val.toString()));
    }
    return <String, String>{};
  }
}
