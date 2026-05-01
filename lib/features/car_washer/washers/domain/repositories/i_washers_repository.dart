import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IWashersRepository {
  Future<Either<Failure, List<WasherEntity>>> getWashers({String? city});
}