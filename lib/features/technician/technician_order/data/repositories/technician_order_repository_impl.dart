// features/technician/technician_requests/data/repositories/technician_requests_repository_impl.dart
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/technician/technician_order/data/models/request_model.dart' as request_model;
import 'package:car_care/features/technician/technician_order/domain/maper/available_map.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/available_requests_entity.dart' hide CustomerEntity, VehicleEntity, ImageEntity;
import '../../domain/entities/request_entity.dart' ;
import '../../domain/repositories/i_order_requests_repository.dart';
import '../data_sources/technician_order_remote_data_source.dart';



class TechnicianOrderRepositoryImpl implements ITechnicianOrderRepository {
  final TechnicianOrderRemoteDataSource _remoteDataSource;

  TechnicianOrderRepositoryImpl(this._remoteDataSource);

 
  // تحويل RequestModel -> RequestEntity
  RequestEntity _mapRequest(request_model.RequestModel model) {
    final item = model.data;
    return RequestEntity(
      success: model.success,
      data: RequestDataEntity(
        id: item.id,
        description: item.description,
        priority: item.priority,
        priorityText: item.priorityText,
        status: item.status,
        statusText: item.statusText,
        customer: CustomerEntity(
          id: item.customer.id,
          name: item.customer.name,
          phone: item.customer.phone,
        ),
        vehicle: VehicleEntity(
          id: item.vehicle.id,
          brand: item.vehicle.brand,
          model: item.vehicle.model,
          year: item.vehicle.year,
          plateNumber: item.vehicle.plateNumber,
        ),
        images: item.images.map((img) => ImageEntity(id: img.id, url: img.url)).toList(),
        myQuotation: item.myQuotation,
        preferredDate: item.preferredDate,
        createdAt: item.createdAt,
        createdAgo: item.createdAgo,
      ),
    );
  }

  @override
  Future<Either<Failure, AvailableRequestsEntity>> fetchAvailableRequests() async {
    try {
      final model = await _remoteDataSource.fetchAvailableRequests();
      return Right(mapAvailable(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, RequestEntity>> fetchRequest(String idRequest) async {
    try {
      final model = await _remoteDataSource.fetchRequest(idRequest);
      return Right(_mapRequest(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}