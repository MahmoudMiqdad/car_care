import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/washers_entity.dart';

abstract class IWashersRepository {

  Future<Either<Failure, WashersEntity>> washers(Map<String, dynamic> params);

}
