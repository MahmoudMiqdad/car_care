// واجهة مستودع مشاركة موقع التوصيل للمالك.
import 'package:car_care/core/errors/filuar.dart';
import 'package:dartz/dartz.dart';

abstract class IOwnerShareLocationRepository {
  Future<Either<Failure, void>> shareLocation({
    required int orderId,
    required double lat,
    required double lng,
  });
}
