// i_requests_repository.dart
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';


abstract class IRequestsRepository {
  Future<Either<Failure, MaintenanceRequestResponseEntity>> getAllMaintenance();
  Future<Either<Failure, MaintenanceRequestResponseEntity>> addMaintenanceRequest(Map<String, dynamic> data);
  Future<Either<Failure, MaintenanceRequestEntity>> showRequest(String id);
  Future<Either<Failure, MaintenanceRequestEntity>> updateRequest(String id, Map<String, dynamic> data);
  Future<Either<Failure, MaintenanceRequestEntity>> deleteRequest(String id);
  Future<Either<Failure, MaintenanceRequestResponseEntity>> pendingRequests();
  Future<Either<Failure, MaintenanceRequestResponseEntity>> completedRequests();
  Future<Either<Failure, MaintenanceRequestResponseEntity>> acceptedRequests();
   Future<Either<Failure, MaintenanceRequestEntity>> cancelRequest(  String cancellationReason,
   String id);
}