import 'package:car_care/features/maintenance/user_rate_job/domain/entities/rate_job_entity.dart';

abstract class RateJobState {
  const RateJobState();
}

class RateJobInitial extends RateJobState {}

class RateJobLoading extends RateJobState {}

class RateJobSuccess extends RateJobState {
  final RateJobEntity result;

  const RateJobSuccess(this.result);
}

class RateJobError extends RateJobState {
  final String message;

  const RateJobError(this.message);
}