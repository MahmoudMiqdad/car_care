import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_technician_jobs_repository.dart';
import 'technician_jobs_state.dart';

class TechnicianJobsCubit extends Cubit<TechnicianJobsState> {
  TechnicianJobsCubit(this._repository)
      : super(TechnicianJobsInitial());

  final ITechnicianJobsRepository _repository;

  Future<void> fetchMyJobs() async {
    emit(TechnicianJobsLoading());

    final result = await _repository.fetchMyJobs();

    result.fold(
      (failure) => emit(TechnicianJobsError(failure.message)),
      (data) => emit(TechnicianJobsLoaded(data)),
    );
  }

  Future<void> fetchAcceptedJobs() async {
    emit(TechnicianJobsLoading());

    final result = await _repository.fetchAcceptedJobs();

    result.fold(
      (failure) => emit(TechnicianJobsError(failure.message)),
      (data) => emit(TechnicianJobsLoaded(data)),
    );
  }

  Future<void> updateJobStatus(
      Map<String, dynamic> data, String jobId) async {
    emit(JobStatusLoading());

    final result = await _repository.updateJobStatus(data, jobId);

    result.fold(
      (failure) => emit(JobStatusError(failure.message)),
      (data) => emit(JobStatusUpdated(data)),
    );
  }
}