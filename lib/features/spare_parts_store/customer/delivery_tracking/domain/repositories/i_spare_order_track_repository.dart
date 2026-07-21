// واجهة مستودع تتبع طلب قطع الغيار.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/entities/spare_order_track_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ISpareOrderTrackRepository {
  Future<Either<Failure, SpareOrderTrackEntity>> trackOrder(int orderId);
}
