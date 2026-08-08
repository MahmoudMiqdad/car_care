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
/// Carries the job id so only that card shows a busy state instead of
/// collapsing the whole page into a loader.
class JobStatusLoading extends TechnicianJobsState {
  final String jobId;

  JobStatusLoading(this.jobId);
}

class JobStatusUpdated extends TechnicianJobsState {
  final UpdateJobStatusEntity data;

  JobStatusUpdated(this.data);
}

class JobStatusError extends TechnicianJobsState {
  final String message;

  JobStatusError(this.message);
}