import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/entities/car_washer_rating_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ICarWasherRatingsRepository {
  Future<Either<Failure, CarWasherRatingsPageEntity>> getRatings(
    int carWasherId, {
    int page = 1,
  });
}
