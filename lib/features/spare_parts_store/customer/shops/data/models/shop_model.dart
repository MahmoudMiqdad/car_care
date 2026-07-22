// نموذج بيانات المتجر القادم من API، يُحوَّل إلى ShopEntity
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_owner_summary_entity.dart';

class ShopModel extends ShopEntity {
  const ShopModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.city,
    required super.isActive,
    required super.owner,
    required super.businessTypes,
    required super.carBrands,
    required super.partCategories,
    required super.createdAt,
    super.status,
    super.rejectionReason,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      isActive: json['is_active'] == true,
      owner: _parseOwner(json['owner']),
      businessTypes: _stringList(json['business_types']),
      carBrands: _stringList(json['car_brands']),
      partCategories: _stringList(json['part_categories']),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
      status: json['status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  static List<ShopModel> listFromResponse(Map<String, dynamic> response) {
    final data = response['data'];

    final List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map && data['data'] is List) {
      items = data['data'] as List;
    } else {
      items = const [];
    }

    return items
        .whereType<Map>()
        .map((e) => ShopModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  static ShopOwnerSummaryEntity? _parseOwner(dynamic value) {
    if (value is! Map) return null;
    return ShopOwnerSummaryEntity(
      id: value['id'] == null ? null : _toInt(value['id']),
      name: value['name']?.toString(),
      email: value['email']?.toString(),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return <String>[];
    return value
        .map((e) {
          if (e is String) return e.trim();
          if (e is Map) return (e['name'] ?? '').toString().trim();
          return e.toString().trim();
        })
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static int _toInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }
}
