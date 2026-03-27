import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IVehicleRepository {
  Future<Either<Failure, List<VehicleEntity>>> getAllVehicles();

  Future<Either<Failure, VehicleEntity>> addVehicle(
    Map<String, dynamic> params,
  );

  Future<Either<Failure, VehicleEntity>> getVehicleDetails(int id);

  Future<Either<Failure, VehicleEntity>> updateVehicle({
    required int id,
    required Map<String, dynamic> params,
  });

  Future<Either<Failure, Unit>> deleteVehicle(int id);
}