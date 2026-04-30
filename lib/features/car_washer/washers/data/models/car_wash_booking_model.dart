import '../../domain/entities/car_wash_booking_entity.dart';

class CarWashBookingModel extends CarWashBookingEntity {
  const CarWashBookingModel({
    required super.success,
    required super.message,
    required super.id,
    required super.serviceType,
    required super.statusText,
    required super.scheduledAt,
    required super.canCancel,
  });

  factory CarWashBookingModel.fromJson(Map<String, dynamic> json) {
    final success = json['success'] == true;
    final message = (json['message'] ?? '').toString();

    final data = json['data'];
    final Map<String, dynamic> d =
        data is Map<String, dynamic> ? data : <String, dynamic>{};

    return CarWashBookingModel(
      success: success,
      message: message,
      id: _toInt(d['id']),
      serviceType: (d['service_type'] ?? '').toString(),
      statusText: (d['status_text'] ?? '').toString(),
      scheduledAt: (d['scheduled_at'] ?? '').toString(),
      canCancel: d['can_cancel'] == true,
    );
  }

  static int _toInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }
}