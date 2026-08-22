import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/data/models/washers_model.dart';
import 'package:car_care/features/vehicle/data/model/vehicle_model.dart'
    show VehicleModel;

class BookingModel extends BookingsEntity {
  const BookingModel({
    required super.id,
    required super.serviceType,
    super.price,
    required super.status,
    required super.statusText,
    required super.scheduledAt,
    required super.notes,
    required super.canCancel,
    required super.vehicle,
    super.carWasher,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final carWasherJson = json['car_washer'];
    final vehicleJson = json['vehicle'];
    return BookingModel(
      id: json['id'],
      serviceType: json['service_type']?.toString() ?? '',
      price: json['price']?.toString(),
      status: json['status']?.toString() ?? '',
      statusText: json['status_text']?.toString() ?? '',
      scheduledAt: json['scheduled_at']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      canCancel: json['can_cancel'] == true,
      vehicle: vehicleJson is Map<String, dynamic>
          ? VehicleModel.fromJson(vehicleJson)
          : VehicleModel.fromJson(const {}),
      carWasher: carWasherJson is Map<String, dynamic>
          ? WasherModel.fromJson(carWasherJson)
          : null,
    );
  }

  static List<BookingModel> listFromResponse(Map<String, dynamic> response) {
    final List<dynamic> data = (response['data'] as List<dynamic>?) ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(BookingModel.fromJson)
        .toList(growable: false);
  }
}
