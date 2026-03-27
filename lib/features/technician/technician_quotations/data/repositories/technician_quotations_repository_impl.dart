import 'package:car_care/features/technician/technician_quotations/domain/entities/technician_quotations_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/errors/excptions.dart';

import '../../domain/repositories/i_technician_quotations_repository.dart';
import '../data_sources/technician_quotations_remote_data_source.dart';
import '../models/submit_quotation_model.dart';

class TechnicianQuotationsRepositoryImpl
    implements ITechnicianQuotationsRepository {
  final TechnicianQuotationsRemoteDataSource _remoteDataSource;

  TechnicianQuotationsRepositoryImpl(this._remoteDataSource);

  SubmitQuotationEntity _map(SubmitQuotationModel model) {
    final data = model.data;

    return SubmitQuotationEntity(
      success: model.success,
      message: model.message,
      data: SubmitQuotationDataEntity(
        id: data.id,
        maintenanceRequestId: data.maintenanceRequestId,
        price: data.price,
        priceFormatted: data.priceFormatted,
        estimatedDays: data.estimatedDays,
        partsIncluded: data.partsIncluded,
        notes: data.notes,
        status: data.status,
        statusText: data.statusText,
        createdAt: data.createdAt,
        createdAgo: data.createdAgo,
      ),
    );
  }

  @override
  Future<Either<Failure, SubmitQuotationEntity>> submitQuotation(
    Map<String, dynamic> data,
    String requestId,
  ) async {
    try {
      final model =
          await _remoteDataSource.updateTechnicianProfile(data, requestId);

      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}