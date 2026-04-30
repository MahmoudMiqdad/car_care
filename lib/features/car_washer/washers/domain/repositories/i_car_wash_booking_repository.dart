import 'package:car_care/core/errors/filuar.dart';
import 'package:dartz/dartz.dart';
import '../entities/car_wash_booking_entity.dart';

abstract class ICarWashBookingRepository {
  Future<Either<Failure, CarWashBookingEntity>> createBooking({
    required int vehicleId,
    required int carWasherId,
    required String scheduledAt,
    required String serviceType,
    String? notes,
  });
}