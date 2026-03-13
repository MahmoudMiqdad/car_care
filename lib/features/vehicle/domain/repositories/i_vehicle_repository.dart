import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/failures.dart';
import '../entities/vehicle_entity.dart';

abstract class IVehicleRepository {

  Future<Either<Failure, VehicleEntity>> myVehiclesPage(Map<String, dynamic> params);
  Future<Either<Failure, VehicleEntity>> addVehicle(Map<String, dynamic> params);
  Future<Either<Failure, VehicleEntity>> vehicleDetails(Map<String, dynamic> params);

}
