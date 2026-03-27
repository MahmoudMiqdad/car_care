import 'package:car_care/core/errors/filuar.dart';

import 'package:car_care/features/maintenance/user_statistics/domain/entities/statistics_entity.dart';
import 'package:dartz/dartz.dart';



abstract class IStatisticsRepository {

  Future<Either<Failure, StatisticsEntity>> statistics();
   

}
