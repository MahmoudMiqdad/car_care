import 'package:car_care/core/errors/filuar.dart';
import 'package:dartz/dartz.dart';

import '../entities/rate_job_entity.dart';

abstract class IRateJobRepository {

  Future<Either<Failure, RateJobEntity>> rateJob(
    String review,
    String rating,
    String quotationId,
  );
}