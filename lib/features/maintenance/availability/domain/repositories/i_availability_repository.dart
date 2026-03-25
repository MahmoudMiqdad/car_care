import 'package:car_care/core/errors/filuar.dart';
import 'package:dartz/dartz.dart';

import '../entities/availability_entity.dart';

abstract class IAvailabilityRepository {

  Future<Either<Failure, AvailabilityEntity>> availability(Map<String, dynamic> params);

}
