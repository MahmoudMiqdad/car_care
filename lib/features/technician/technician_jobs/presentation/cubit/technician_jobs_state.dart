import '../../domain/entities/technician_jobs_entity.dart';
import '../../domain/entities/update_job_status_entity.dart';

abstract class TechnicianJobsState {}

class TechnicianJobsInitial extends TechnicianJobsState {}

class TechnicianJobsLoading extends TechnicianJobsState {}

class TechnicianJobsLoaded extends TechnicianJobsState {
  final TechnicianJobsEntity jobs;

  TechnicianJobsLoaded(this.jobs);
}

class TechnicianJobsError extends TechnicianJobsState {
  final String message;

  TechnicianJobsError(this.message);
}

/// update status
class JobStatusLoading extends TechnicianJobsState {}

class JobStatusUpdated extends TechnicianJobsState {
  final UpdateJobStatusEntity data;

  JobStatusUpdated(this.data);
}

class JobStatusError extends TechnicianJobsState {
  final String message;

  JobStatusError(this.message);
}