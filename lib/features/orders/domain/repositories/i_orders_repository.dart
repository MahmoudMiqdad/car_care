import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/orders_entity.dart';

abstract class IOrdersRepository {

  Future<Either<Failure, OrdersEntity>> orders(Map<String, dynamic> params);
  Future<Either<Failure, OrdersEntity>> orderDetails(Map<String, dynamic> params);

}
