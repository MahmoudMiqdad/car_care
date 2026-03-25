import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/domain/repositories/abstract/i_vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class VehicleRepositoryImpl implements IVehicleRepository {
  const VehicleRepositoryImpl(this._remoteDataSource);

  final VehicleRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<VehicleEntity>>> getAllVehicles() async {
    try {
      final vehicles = await _remoteDataSource.getAllVehicles();
      return Right(vehicles);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(
        Failure(message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> addVehicle(
    Map<String, dynamic> params,
  ) async {
    try {
      final vehicle = await _remoteDataSource.addVehicle(params);
      return Right(vehicle);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
  return Left(Failure(message: e.toString()));
}
  }

  @override
  Future<Either<Failure, VehicleEntity>> getVehicleDetails(int id) async {
    try {
      final vehicle = await _remoteDataSource.getVehicleDetails(id);
      return Right(vehicle);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(
        Failure(message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> updateVehicle({
    required int id,
    required Map<String, dynamic> params,
  }) async {
    try {
      final vehicle = await _remoteDataSource.updateVehicle(
        id: id,
        data: params,
      );
      return Right(vehicle);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(
        Failure(message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVehicle(int id) async {
    try {
      await _remoteDataSource.deleteVehicle(id);
      return const Right(unit);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(
        Failure(message: 'حدث خطأ غير متوقع'),
      );
    }
  }
}