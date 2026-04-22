import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/bookings_entity.dart';

abstract class IBookingsRepository {

  Future<Either<Failure, BookingsEntity>> bookings(Map<String, dynamic> params);

}
