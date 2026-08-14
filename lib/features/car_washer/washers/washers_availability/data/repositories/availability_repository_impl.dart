import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/data/data_sources/availability_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/domain/entities/availability_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/domain/repositories/i_availability_repository.dart';

class AvailabilityRepositoryImpl implements IAvailabilityRepository {
  const AvailabilityRepositoryImpl(this._remote);

  final AvailabilityRemoteDataSource _remote;

  @override
  Future<Either<Failure, AvailabilityEntity>> updateAvailability(
    bool isAvailable,
  ) async {
    try {
      await _remote.updateAvailability(isAvailable);
      return Right(AvailabilityEntity(isAvailable: isAvailable));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء تحديث حالة التوفر'));
    }
  }
}
