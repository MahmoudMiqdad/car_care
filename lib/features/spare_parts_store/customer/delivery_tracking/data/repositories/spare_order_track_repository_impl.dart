// تنفيذ مستودع تتبع الطلب — يحوّل النموذج إلى كيان.
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/data/data_sources/spare_order_track_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/entities/spare_order_track_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/repositories/i_spare_order_track_repository.dart';
import 'package:dartz/dartz.dart';

class SpareOrderTrackRepositoryImpl implements ISpareOrderTrackRepository {
  final SpareOrderTrackRemoteDataSource _remote;
  SpareOrderTrackRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, SpareOrderTrackEntity>> trackOrder(int orderId) async {
    try {
      final model = await _remote.trackOrder(orderId);
      final d = model.data;
      return Right(SpareOrderTrackEntity(
        orderId: d?.orderId,
        orderStatus: d?.orderStatus,
        trackingPoints: d?.trackingPoints
                .map((e) => SpareTrackPointEntity(
                      latitude: e.latitude,
                      longitude: e.longitude,
                      timestamp: e.timestamp,
                    ))
                .toList() ??
            [],
        lastLocation: d?.lastLocation != null
            ? SpareTrackPointEntity(
                latitude: d!.lastLocation!.latitude,
                longitude: d.lastLocation!.longitude,
                timestamp: d.lastLocation!.timestamp,
              )
            : null,
      ));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
