// تنفيذ مستودع مشاركة موقع التوصيل للمالك.
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/data/data_sources/owner_share_location_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/domain/repositories/i_owner_share_location_repository.dart';
import 'package:dartz/dartz.dart';

class OwnerShareLocationRepositoryImpl implements IOwnerShareLocationRepository {
  final OwnerShareLocationRemoteDataSource _remote;
  OwnerShareLocationRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, void>> shareLocation({
    required int orderId,
    required double lat,
    required double lng,
  }) async {
    try {
      await _remote.shareLocation(orderId: orderId, lat: lat, lng: lng);
      return const Right(null);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
