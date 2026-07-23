
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/data/data_sources/provider_order_remote_data_source.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/data/models/fuel_provider_order_model.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/entities/provider_order_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/repositories/i_provider_order_repository.dart';
import 'package:dartz/dartz.dart';

class FuelProviderOrderRepositoryImpl implements IFuelProviderOrderRepository {
  final FuelProviderOrderRemoteDataSource _remote;
  FuelProviderOrderRepositoryImpl(this._remote);

FuelOrderEntity _mapOrder(FuelOrderData? d) => FuelOrderEntity(
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
          ? FuelOrderVehicleEntity(
              id: d!.vehicle!.id,
              brand: d.vehicle!.brand,
              model: d.vehicle!.model,
              year: d.vehicle!.year,
              plateNumber: d.vehicle!.plateNumber,
              currentKm: d.vehicle!.currentKm,
              ownerName: d.vehicle!.ownerName,
            )
          : null,
      fuelProvider: d?.fuelProvider != null
          ? FuelOrderProviderEntity(
              id: d!.fuelProvider!.id,
              companyName: d.fuelProvider!.companyName,
              phone: d.fuelProvider!.phone,
              currentLat: d.fuelProvider!.currentLat,
              currentLng: d.fuelProvider!.currentLng,
            )
          : null,
    );
  Future<Either<Failure, T>> _call<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FuelOrderEntity>> getOrder(int id) =>
      _call(() async => _mapOrder((await _remote.getOrder(id)).data));

  @override
  Future<Either<Failure, FuelOrderEntity>> acceptOrder(int id) =>
      _call(() async => _mapOrder((await _remote.acceptOrder(id)).data));

  @override
  Future<Either<Failure, FuelOrderEntity>> completeOrder(int id) =>
      _call(() async => _mapOrder((await _remote.completeOrder(id)).data));

  @override
  Future<Either<Failure, FuelOrderEntity>> cancelOrder(int id, String reason) =>
      _call(() async => _mapOrder((await _remote.cancelOrder(id, reason)).data));

  @override
  Future<Either<Failure, List<FuelOrderEntity>>> getMyOrders() =>
      _call(() async => (await _remote.getMyOrders()).data.map(_mapOrder).toList());
       @override
  Future<Either<Failure, List<FuelOrderEntity>>> getavailableOrders() =>
      _call(() async => (await _remote.getavailableOrders()).data.map(_mapOrder).toList());
       @override
     Future<Either<Failure, FuelOrderEntity>> ShareLocation(int id  ,int latitude ,int longitude) =>
      _call(() async => _mapOrder((await _remote.ShareLocation(id,latitude,longitude)).data));
}
