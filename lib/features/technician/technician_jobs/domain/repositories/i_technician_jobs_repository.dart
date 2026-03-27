import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/technician_jobs_entity.dart';
import '../entities/update_job_status_entity.dart';

abstract class ITechnicianJobsRepository {
  Future<Either<Failure, TechnicianJobsEntity>> fetchMyJobs();

  Future<Either<Failure, TechnicianJobsEntity>> fetchAcceptedJobs();

  Future<Either<Failure, UpdateJobStatusEntity>> updateJobStatus(
    Map<String, dynamic> data,
    String jobId,
  );
}