import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/provider_order_entity.dart';


abstract class IFuelProviderOrderRepository {
  Future<Either<Failure, FuelOrderEntity>> getOrder(int id);
  Future<Either<Failure, FuelOrderEntity>> acceptOrder(int id);
  Future<Either<Failure, FuelOrderEntity>> completeOrder(int id);
  Future<Either<Failure, FuelOrderEntity>> cancelOrder(int id, String reason);
  Future<Either<Failure, List<FuelOrderEntity>>> getMyOrders();
  Future<Either<Failure, List<FuelOrderEntity>>> getavailableOrders();
    Future<Either<Failure, FuelOrderEntity>> ShareLocation(int id  ,int latitude ,int longitude);
}
