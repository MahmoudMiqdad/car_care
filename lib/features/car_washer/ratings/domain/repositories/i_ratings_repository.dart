import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/ratings_entity.dart';

abstract class IRatingsRepository {

  Future<Either<Failure, RatingsEntity>> ratings(Map<String, dynamic> params);

}
