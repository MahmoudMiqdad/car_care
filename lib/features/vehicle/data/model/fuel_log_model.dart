import 'package:car_care/features/vehicle/domain/entities/fuel_log_entity.dart';

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  }
  return null;
}

int _toInt(dynamic value) => _toNullableInt(value) ?? 0;

double? _toNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class FuelLogModel extends FuelLogEntity {
  const FuelLogModel({
    super.id,
    super.vehicleId,
    super.amount,
    super.fuelType,
    super.cost,
    super.kmAtFill,
    super.odometerImage,
    super.createdAt,
  });

  factory FuelLogModel.fromJson(Map<String, dynamic> json) {
    return FuelLogModel(
      id: _toNullableInt(json['id']),
      vehicleId: _toNullableInt(json['vehicle_id']),
      amount: _toNullableDouble(json['amount']),
      fuelType: json['fuel_type']?.toString(),
      cost: _toNullableDouble(json['cost']),
      kmAtFill: _toNullableInt(json['km_at_fill']),
      odometerImage: json['odometer_image']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

/// Maps the Laravel-style paginator envelope:
/// { current_page, data: [...], per_page, total }
class FuelLogPageModel extends FuelLogPageEntity {
  const FuelLogPageModel({
    required super.currentPage,
    required super.items,
    required super.perPage,
    required super.total,
  });

  factory FuelLogPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['data'] as List<dynamic>? ?? [];
    return FuelLogPageModel(
      currentPage: _toInt(json['current_page']),
      items: rawItems
          .map((e) => FuelLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      perPage: _toInt(json['per_page']),
      total: _toInt(json['total']),
    );
  }
}
