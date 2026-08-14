import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/data/data_sources/car_washer_ratings_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/entities/car_washer_rating_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/repositories/i_car_washer_ratings_repository.dart';
import 'package:dartz/dartz.dart';

class CarWasherRatingsRepoImpl implements ICarWasherRatingsRepository {
  const CarWasherRatingsRepoImpl(this._remote);
  final CarWasherRatingsRemoteDataSource _remote;

  @override
  Future<Either<Failure, CarWasherRatingsPageEntity>> getRatings(
    int carWasherId, {
    int page = 1,
  }) async {
    try {
      final result = await _remote.getRatings(carWasherId, page: page);
      return Right(result);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب التقييمات'));
    }
  }
}
