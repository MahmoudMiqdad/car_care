// requests_repository_impl.dart
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/mapper/maintenance_request_mapper.dart';
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/maintenance/user_requests/data/data_sources/requests_remote_data_source.dart';

class RequestsRepositoryImpl implements IRequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MaintenanceRequestResponseEntity>> getAllMaintenance() async {
    try {
      final model = await remoteDataSource.getAllMaintenance();
      final responseEntity = MaintenanceRequestResponseEntity(
        success: model.success,
        message: model.message,
        data: model.data.map((e) => e.toEntity()).toList(),
      );
      return Right(responseEntity);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء جلب الصيانات'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestResponseEntity>> addMaintenanceRequest(Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.addMaintenanceRequest(data);
      final responseEntity = MaintenanceRequestResponseEntity(
        success: model.success,
        message: model.message,
        data: model.data.map((e) => e.toEntity()).toList(),
      );
      return Right(responseEntity);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء إضافة طلب الصيانة'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> showRequest(String id) async {
    try {
      final model = await remoteDataSource.showRequest(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء عرض الطلب'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> updateRequest(String id, Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.updateRequest(id, data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء تحديث الطلب'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> deleteRequest(String id) async {
    try {
      final model = await remoteDataSource.deletRequest(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء حذف الطلب'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestResponseEntity>> pendingRequests() async {
    try {
      final model = await remoteDataSource.pendingRequests();
      final responseEntity = MaintenanceRequestResponseEntity(
        success: model.success,
        message: model.message,
        data: model.data.map((e) => e.toEntity()).toList(),
      );
      return Right(responseEntity);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء جلب الطلبات المعلقة'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestResponseEntity>> completedRequests() async {
    try {
      final model = await remoteDataSource.completedRequests();
      final responseEntity = MaintenanceRequestResponseEntity(
        success: model.success,
        message: model.message,
        data: model.data.map((e) => e.toEntity()).toList(),
      );
      return Right(responseEntity);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء جلب الطلبات المكتملة'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestResponseEntity>> acceptedRequests() async {
    try {
      final model = await remoteDataSource.acceptedRequests();
      final responseEntity = MaintenanceRequestResponseEntity(
        success: model.success,
        message: model.message,
        data: model.data.map((e) => e.toEntity()).toList(),
      );
      return Right(responseEntity);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء جلب الطلبات المقبولة'));
    }
  }
  
  @override
  Future<Either<Failure, MaintenanceRequestEntity>> cancelRequest(String cancellationReason, String id)async {
    try {
      final model = await remoteDataSource.cancelRequest(id,cancellationReason);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء التراجع عن الطلب'));
    }
  }
}