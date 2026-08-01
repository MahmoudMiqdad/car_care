import 'package:car_care/features/technician_sos/domain/entities/update_request_status_technician_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/technician_sos_entity.dart';

abstract class ITechnicianSosRepository {
  Future<Either<Failure, List<TechnicianSosEntity>>> getAvailableRequests();
  Future<Either<Failure, TechnicianSosEntity>> getRequest(int id);
  Future<Either<Failure, TechnicianSosEntity>> acceptRequest(int id);
  Future<Either<Failure, TechnicianSosEntity>> updateStatus(int id, String status);

  /// Technician cancels their own response; backend reopens the request.
  /// Returns the backend success message.
  Future<Either<Failure, String>> cancelResponse(int id, String reason);
  Future<Either<Failure, List<TechnicianSosEntity>>> myRequests();
  Future<Either<Failure, Map<String, dynamic>>> statistics();
  Future<Either<Failure, UpdateRequestStatusTechnicianEntity>> shareLocation(int id, double lat, double lng);
}