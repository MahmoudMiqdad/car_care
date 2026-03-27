import 'package:flutter_bloc/flutter_bloc.dart';
import 'rate_job_state.dart';

import 'package:car_care/features/maintenance/user_rate_job/domain/repositories/i_rate_job_repository.dart';

class RateJobCubit extends Cubit<RateJobState> {
  final IRateJobRepository _repository;

  RateJobCubit(this._repository) : super(RateJobInitial());

  Future<void> rateJob(String review, String rating, String quotationId) async {
    emit(RateJobLoading());

    final result = await _repository.rateJob(review, rating, quotationId);

    result.fold(
      (failure) => emit(RateJobError(failure.message)),
      (data) => emit(RateJobSuccess(data)),
    );
  }
}
