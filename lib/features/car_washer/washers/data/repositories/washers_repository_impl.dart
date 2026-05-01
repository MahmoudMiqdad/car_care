import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/car_washer/washers/data/data_sources/washers_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/domain/repositories/i_washers_repository.dart';
import 'package:dartz/dartz.dart';

class WashersRepositoryImpl implements IWashersRepository {
  const WashersRepositoryImpl(this._remote);
  final WashersRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<WasherEntity>>> getWashers({String? city}) async {
    try {
      final items = await _remote.getWashers(city: city);
      return Right(items); 
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب المغاسل'));
    }
  }
}