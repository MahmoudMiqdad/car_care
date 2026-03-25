import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/jobs_entity.dart';

abstract class IJobsRepository {

  Future<Either<Failure, JobsEntity>> jobs(Map<String, dynamic> params);

}
