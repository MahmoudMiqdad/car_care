import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IFuelProviderStatisticsRepository {
  Future<Either<Failure, FuelProviderStatisticsEntity>> getStatistics();
}