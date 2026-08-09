// مسؤول عن تعريف عقد جلب الإعلانات الفعالة حسب موضع العرض.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IAdvertisementRepository {
  Future<Either<Failure, List<AdvertisementEntity>>> getActiveAdvertisements(
    AdvertisementPlacement placement,
  );
}
