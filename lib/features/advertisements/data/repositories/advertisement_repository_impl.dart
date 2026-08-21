// مسؤول عن تنفيذ جلب الإعلانات الفعالة عبر مصدر البيانات البعيد.
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/advertisements/data/data_sources/advertisement_remote_data_source.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/domain/repositories/i_advertisement_repository.dart';
import 'package:dartz/dartz.dart';

class AdvertisementRepositoryImpl implements IAdvertisementRepository {
   AdvertisementRepositoryImpl(this._remote);
  final AdvertisementRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<AdvertisementEntity>>> getActiveAdvertisements(
    AdvertisementPlacement placement,
  ) async {
    try {
      final items = await _remote.getActiveAdvertisements(placement);
      return Right(items);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'تعذر تحميل الإعلانات'));
    }
  }
}
