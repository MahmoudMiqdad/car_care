// requests_repository_impl.dart
import 'package:car_care/core/domain/entities/base_response_entity.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart' as model;
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/mapper/maintenance_request_mapper.dart';
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/maintenance/user_requests/data/data_sources/requests_remote_data_source.dart';
import 'package:dio/dio.dart';

class RequestsRepositoryImpl implements IRequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImpl(this.remoteDataSource);


  MaintenanceRequestEntity _map(model.MaintenanceRequestModel model) => mapMaintenanceRequest(model);

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> getAllMaintenance() async {
    try {
      final model = await remoteDataSource.getAllMaintenance();
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب الصيانات'));
    }
  }

@override
Future<Either<Failure, BaseResponseEntity>> addMaintenanceRequest(
  FormData formData,
) async {
  try {
    final model = await remoteDataSource.addMaintenanceRequest(formData);

    return Right(model.toEntity());
  } catch (e) {
    return const Left(
      Failure(message: 'حدث خطأ أثناء إضافة طلب الصيانة'),
    );
  }
} 


  @override
  Future<Either<Failure, MaintenanceRequestEntity>> showRequest(String id) async {
    try {
      final model = await remoteDataSource.showRequest(id);
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء عرض الطلب'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> updateRequest(String id, Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.updateRequest(id, data);
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء تحديث الطلب'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> deleteRequest(String id) async {
    try {
      final model = await remoteDataSource.deletRequest(id);
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء حذف الطلب'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> pendingRequests() async {
    try {
      final model = await remoteDataSource.pendingRequests();
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب الطلبات المعلقة'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> completedRequests() async {
    try {
      final model = await remoteDataSource.completedRequests();
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب الطلبات المكتملة'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> acceptedRequests() async {
    try {
      final model = await remoteDataSource.acceptedRequests();
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب الطلبات المقبولة'));
    }
  }

  @override
  Future<Either<Failure, MaintenanceRequestEntity>> cancelRequest(String cancellationReason, String id) async {
    try {
      final model = await remoteDataSource.cancelRequest(id, cancellationReason);
      return Right(_map(model));
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء التراجع عن الطلب'));
    }
  }
}
