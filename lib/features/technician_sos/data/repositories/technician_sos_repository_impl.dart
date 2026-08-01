import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/technician_sos/data/data_sources/technician_sos_remote_data_source.dart';
import 'package:car_care/features/technician_sos/data/models/technician_sos_model.dart';
import 'package:car_care/features/technician_sos/data/models/update_request_status_technician_model.dart';
import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';
import 'package:car_care/features/technician_sos/domain/entities/update_request_status_technician_entities.dart';
import 'package:car_care/features/technician_sos/domain/repositories/i_technician_sos_repository.dart';
import 'package:dartz/dartz.dart';

const String _genericError = 'حدث خطأ أثناء تنفيذ العملية، حاول مرة أخرى';

class TechnicianSosRepositoryImpl implements ITechnicianSosRepository {
  final TechnicianSosRemoteDataSource _remote;

  TechnicianSosRepositoryImpl(this._remote);


  TechnicianSosEntity? _mapToEntity(TechnicianSosData? data) {
    if (data == null) return null;

    final vehicle = data.vehicle;
    final tech = data.technician;

    return TechnicianSosEntity(
      id: data.id,
      lat: data.lat,
      lng: data.lng,

      description: data.description,
      status: data.status,
      statusText: data.statusText,
      priority: data.priority,


      vehicleId: vehicle?.id,
      vehicleBrand: vehicle?.brand,
      vehicleModel: vehicle?.model,
      vehicleYear: vehicle?.year,
      plateNumber: vehicle?.plateNumber,
      currentKm: vehicle?.currentKm,
      vehicleImage: vehicle?.image,
      vehicleImagePath: vehicle?.imagePath,
      vehicleStatus: vehicle?.status,
      needsMaintenance: vehicle?.needsMaintenance,

 
      ownerId: vehicle?.owner?.id,
      ownerName: vehicle?.owner?.name,


      technicianId: tech?.id,
      technicianName: tech?.name,
      technicianPhone: tech?.phone,

      canCancel: data.canCancel,

      createdAt: data.createdAt,
      createdAgo: data.createdAgo,
    );
  }

UpdateRequestStatusTechnicianEntity? _mapToEntitystats(
    UpdateRequestStatusTechnicianData? data) {
  if (data == null) return null;

  return UpdateRequestStatusTechnicianEntity(
    id: data.id,
    lat: data.lat,
    lng: data.lng,

    description: data.description,
    status: data.status,
    statusText: data.statusText,
    priority: data.priority,

    canCancel: data.canCancel,

    createdAt: data.createdAt,
    createdAgo: data.createdAgo,
  );
}
  @override
  Future<Either<Failure, List<TechnicianSosEntity>>>
      getAvailableRequests() async {
    try {
      final result = await _remote.getAvailableRequests();

      final entities = result
          .map(_mapToEntity)
          .whereType<TechnicianSosEntity>()
          .toList();

      return Right(entities);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }

  @override
  Future<Either<Failure, TechnicianSosEntity>> getRequest(int id) async {
    try {
      final result = await _remote.getRequest(id);

      final entity = _mapToEntity(result);

      if (entity == null) {
        return Left(Failure(message: "Request not found"));
      }

      return Right(entity);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }

  @override
  Future<Either<Failure, TechnicianSosEntity>> acceptRequest(int id) async {
    try {
      final result = await _remote.acceptRequest(id);

      final entity = _mapToEntity(result);

      if (entity == null) {
        return Left(Failure(message: "Accept failed"));
      }

      return Right(entity);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }

  @override
  Future<Either<Failure, TechnicianSosEntity>> updateStatus(
    int id,
    String status,
  ) async {
    try {
      final result = await _remote.updateStatus(id, status);

      final entity = _mapToEntity(result);

      if (entity == null) {
        return Left(Failure(message: "Update failed"));
      }

      return Right(entity);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }

  @override
  Future<Either<Failure, String>> cancelResponse(int id, String reason) async {
    try {
      final result = await _remote.cancelResponse(id, reason);
      return Right(result.message ?? 'تم إلغاء الاستجابة');
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }

  @override
  Future<Either<Failure, List<TechnicianSosEntity>>> myRequests() async {
    try {
      final result = await _remote.myRequests();

      final entities = result
          .map(_mapToEntity)
          .whereType<TechnicianSosEntity>()
          .toList();

      return Right(entities);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> statistics() async {
    try {
      final result = await _remote.statistics();

      return Right(result['data']);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }

  @override
  Future<Either<Failure, UpdateRequestStatusTechnicianEntity>> shareLocation(
    int id,
    double lat,
    double lng,
  ) async {
    try {
     final result =  await _remote.shareLocation( sosId: id,lat: lat,lng:  lng);
        

          final entity = _mapToEntitystats(result);
             if (entity == null) {
        return Left(Failure(message: "Request not found"));
      }
      return  Right(entity);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: _genericError));
    }
  }
}