import 'package:car_care/core/config/env.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';

class WasherModel extends WasherEntity {
  const WasherModel({
    required super.id,
    required super.shopName,
    required super.city,
    required super.address,
    required super.logoUrl,
    required super.phone,
    required super.services,
    required super.servicePrices,
    required super.averageRating,
    required super.ratingsCount,
    required super.isAvailable,
    required super.isVerified,
    required super.openTime,
    required super.closeTime,
  });

  factory WasherModel.fromJson(Map<String, dynamic> json) {
    final servicesRaw = json['services'];
    final services = servicesRaw is List
        ? servicesRaw.map((e) => e.toString()).toList()
        : <String>[];

    final sp = json['service_prices'];
    final Map<String, int> servicePrices = <String, int>{};
    if (sp is Map) {
      sp.forEach((k, v) {
        servicePrices[k.toString()] = _toInt(v);
      });
    }

    final (openTime, closeTime) = _parseWorkingHours(json['working_hours']);

    return WasherModel(
      id: _toInt(json['id']),
      shopName: (json['shop_name'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      logoUrl: _logoUrl(json['logo']),
      phone: (json['phone'] ?? '').toString(),
      services: services,
      servicePrices: servicePrices,
      averageRating: _toDouble(json['average_rating']),
      ratingsCount: _toInt(json['ratings_count']),
      isAvailable: json['is_available'] == true,
      isVerified: json['is_verified'] == true,
      openTime: openTime,
      closeTime: closeTime,
    );
  }

  static List<WasherModel> listFromResponse(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return <WasherModel>[];

    final items = data['data'];
    if (items is! List) return <WasherModel>[];

    return items
        .whereType<Map>()
        .map((e) => WasherModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  static (String, String) _parseWorkingHours(dynamic value) {
    if (value is! Map || value.isEmpty) return ('', '');

    final sat = value['sat']?.toString() ?? '';
    final satParsed = _splitRange(sat);
    if (satParsed.$1.isNotEmpty || satParsed.$2.isNotEmpty) return satParsed;

    for (final v in value.values) {
      final s = v?.toString() ?? '';
      final parsed = _splitRange(s);
      if (parsed.$1.isNotEmpty || parsed.$2.isNotEmpty) return parsed;
    }

    return ('', '');
  }

  static (String, String) _splitRange(String range) {
    final s = range.trim();
    if (s.isEmpty) return ('', '');
    if (!s.contains('-')) return (s, '');
    final parts = s.split('-');
    if (parts.length < 2) return (s, '');
    return (parts.first.trim(), parts.last.trim());
  }

  static String? _logoUrl(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http')) return raw;

    final base = Uri.parse(Env.baseUrl);
    final origin = '${base.scheme}://${base.authority}';
    final normalized = raw.startsWith('/') ? raw.substring(1) : raw;
    return '$origin/storage/$normalized';
  }

  static int _toInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static double _toDouble(dynamic v, {double fallback = 0}) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }
}
