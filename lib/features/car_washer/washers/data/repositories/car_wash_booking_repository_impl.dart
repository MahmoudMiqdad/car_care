import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/car_wash_booking_entity.dart';
import '../../domain/repositories/i_car_wash_booking_repository.dart';
import '../data_sources/car_wash_booking_remote_data_source.dart';

class CarWashBookingRepositoryImpl implements ICarWashBookingRepository {
  const CarWashBookingRepositoryImpl(this._remote);
  final CarWashBookingRemoteDataSource _remote;

  @override
  Future<Either<Failure, CarWashBookingEntity>> createBooking({
    required int vehicleId,
    required int carWasherId,
    required String scheduledAt,
    required String serviceType,
    String? notes,
  }) async {
    try {
      final res = await _remote.createBooking(
        vehicleId: vehicleId,
        carWasherId: carWasherId,
        scheduledAt: scheduledAt,
        serviceType: serviceType,
        notes: notes,
      );
      return Right(res);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء إنشاء الحجز'));
    }
  }
}