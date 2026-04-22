import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/statistics_entity.dart';

abstract class IStatisticsRepository {

  Future<Either<Failure, StatisticsEntity>> statistics(Map<String, dynamic> params);

}
