import 'package:car_care/features/technician/technician_jobs/data/models/my_jobs_model.dart';
import 'package:car_care/features/technician/technician_jobs/data/models/update_job_status_model.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/errors/excptions.dart';
import '../../domain/entities/technician_jobs_entity.dart';
import '../../domain/entities/update_job_status_entity.dart';
import '../../domain/repositories/i_technician_jobs_repository.dart';
import '../data_sources/technician_jobs_remote_data_source.dart';

class TechnicianJobsRepositoryImpl implements ITechnicianJobsRepository {
  final TechnicianJobsRemoteDataSource _remoteDataSource;

  TechnicianJobsRepositoryImpl(this._remoteDataSource);

  TechnicianJobsEntity _mapJobs(MyJobsModel model) {
    return TechnicianJobsEntity(
      success: model.success,
      jobs: model.data.data.map((e) {
        final request = e.maintenanceRequest;
        final vehicle = request?.vehicle;
        final customer = request?.user;
        return JobEntity(
          id: e.id,
          status: e.status,
          scheduledDate: e.scheduledDate,
          notes: e.notes,
          maintenanceRequestId: e.maintenanceRequestId,
          description: request?.description ?? '',
          priority: request?.priority ?? '',
          customerName: customer?.name ?? '',
          customerPhone: customer?.phone ?? '',
          vehicleBrand: vehicle?.brand ?? '',
          vehicleModel: vehicle?.model ?? '',
          vehicleYear: vehicle?.year ?? '',
          plateNumber: vehicle?.plateNumber ?? '',
          quotationPrice: e.quotation?.price,
          estimatedDays: e.quotation?.estimatedDays,
        );
      }).toList(),
    );
  }

  UpdateJobStatusEntity _mapUpdate(UpdateJobStatusModel model) {
    return UpdateJobStatusEntity(
      success: model.success,
      message: model.message,
    );
  }

  @override
  Future<Either<Failure, TechnicianJobsEntity>> fetchMyJobs() async {
    try {
      final model = await _remoteDataSource.fetchmyJobs();
      return Right(_mapJobs(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, TechnicianJobsEntity>> fetchAcceptedJobs() async {
    try {
      final model = await _remoteDataSource.fetchmyacceptedJobs();
      return Right(_mapJobs(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, UpdateJobStatusEntity>> updateJobStatus(
    Map<String, dynamic> data,
    String jobId,
  ) async {
    try {
      final model =
          await _remoteDataSource.changeAvailability(data, jobId);

      return Right(_mapUpdate(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}