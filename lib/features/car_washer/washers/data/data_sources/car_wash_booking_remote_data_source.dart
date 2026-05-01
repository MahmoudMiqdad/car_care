import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import '../models/car_wash_booking_model.dart';

class CarWashBookingRemoteDataSource {
  const CarWashBookingRemoteDataSource(this._apiService);
  final ApiService _apiService;

  Future<CarWashBookingModel> createBooking({
    required int vehicleId,
    required int carWasherId,
    required String scheduledAt, // "YYYY-MM-DD HH:mm:ss"
    required String serviceType, // basic|vip|premium
    String? notes,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.carwashBookings,
      data: {
        'vehicle_id': vehicleId,
        'car_washer_id': carWasherId,
        'scheduled_at': scheduledAt,
        'service_type': serviceType,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );

    return CarWashBookingModel.fromJson(response);
  }
}