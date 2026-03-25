import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/requests_entity.dart';

abstract class IRequestsRepository {

  Future<Either<Failure, RequestsEntity>> requests(Map<String, dynamic> params);

}
