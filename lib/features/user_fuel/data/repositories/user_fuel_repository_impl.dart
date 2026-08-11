import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/user_fuel/data/data_sources/user_fuel_remote_data_source.dart';
import 'package:car_care/features/user_fuel/data/model/user_fuel_order_model.dart';
import 'package:car_care/features/user_fuel/data/model/user_fuel_track_model.dart';

import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_track_entity.dart';
import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:dartz/dartz.dart';

class UserFuelRepositoryImpl implements IUserFuelRepository {
  final UserFuelRemoteDataSource _remote;
  UserFuelRepositoryImpl(this._remote);

  Future<Either<Failure, T>> _call<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  UserFuelOrderEntity _mapOrder(UserFuelOrderData? d) => UserFuelOrderEntity(
    id: d?.id,
    fuelType: d?.fuelType,
    amount: d?.amount,
    deliveryAddress: d?.deliveryAddress,
    deliveryLatitude: d?.deliveryLatitude,
    deliveryLongitude: d?.deliveryLongitude,
    totalPrice: d?.totalPrice,
    status: d?.status,
    statusText: d?.statusText,
    scheduledTime: d?.scheduledTime,
    notes: d?.notes,
    createdAt: d?.createdAt,
    canCancel: d?.canCancel,
    vehicle: d?.vehicle != null
        ? UserFuelOrderVehicleEntity(
            id: d!.vehicle!.id,
            brand: d.vehicle!.brand,
            model: d.vehicle!.model,
            year: d.vehicle!.year,
            plateNumber: d.vehicle!.plateNumber,
            currentKm: d.vehicle!.currentKm,
            ownerName: d.vehicle!.ownerName,
            image: d.vehicle!.image,
            imagePath: d.vehicle!.imagePath,
          )
        : null,
    fuelProvider: d?.fuelProvider != null
        ? UserFuelOrderProviderEntity(
            id: d!.fuelProvider!.id,
            companyName: d.fuelProvider!.companyName,
            phone: d.fuelProvider!.phone,
            currentLat: d.fuelProvider!.currentLat,
            currentLng: d.fuelProvider!.currentLng,
          )
        : null,
  );

  UserFuelTrackEntity _mapTrack(UserFuelTrackData? d) => UserFuelTrackEntity(
    orderId: d?.orderId,
    orderStatus: d?.orderStatus,
    provider: d?.provider != null
        ? UserFuelTrackProviderEntity(
            id: d!.provider!.id,
            companyName: d.provider!.companyName,
            phone: d.provider!.phone,
          )
        : null,
    currentLocation: d?.currentLocation != null
        ? UserFuelTrackLocationEntity(
            latitude: d!.currentLocation!.latitude,
            longitude: d.currentLocation!.longitude,
            timestamp: d.currentLocation!.timestamp,
          )
        : null,
    trackingPath:
        d?.trackingPath
            .map(
              (e) => UserFuelTrackLocationEntity(
                latitude: e.latitude,
                longitude: e.longitude,
                timestamp: e.timestamp,
              ),
            )
            .toList() ??
        [],
  );

  @override
  Future<Either<Failure, List<UserFuelOrderEntity>>> getAllOrders() => _call(
    () async => (await _remote.getAllOrders()).data.map(_mapOrder).toList(),
  );

  @override
  Future<Either<Failure, UserFuelOrderEntity>> getOrder(int id) =>
      _call(() async => _mapOrder((await _remote.getOrder(id)).data));

  @override
  Future<Either<Failure, UserFuelOrderEntity>> addEmergencyOrder(
    Map<String, dynamic> data,
  ) => _call(
    () async => _mapOrder((await _remote.addEmergencyOrder(data)).data),
  );

  @override
  Future<Either<Failure, void>> cancelOrder(int id, String reason) =>
      _call(() async => _remote.cancelOrder(id, reason));

  @override
  Future<Either<Failure, UserFuelTrackEntity>> trackOrder(int id) =>
      _call(() async => _mapTrack((await _remote.trackOrder(id)).data));
}
