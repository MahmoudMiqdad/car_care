import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/technician_statistics_entity.dart';

abstract class ITechnicianStatisticsRepository {
  Future<Either<Failure, TechnicianStatisticsEntity>> getStatistics();
}