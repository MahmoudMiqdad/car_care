
import 'package:car_care/core/errors/filuar.dart';
import 'package:dartz/dartz.dart';

import '../entities/available_requests_entity.dart';
import '../entities/request_entity.dart';

abstract class ITechnicianOrderRepository {

  Future<Either<Failure, AvailableRequestsEntity>> fetchAvailableRequests();


  Future<Either<Failure, RequestEntity>> fetchRequest(String idRequest);
}