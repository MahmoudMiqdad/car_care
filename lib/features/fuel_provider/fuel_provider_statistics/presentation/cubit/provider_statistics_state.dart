
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';

abstract class FuelProviderStatisticsState {}
class FuelProviderStatisticsInitial extends FuelProviderStatisticsState {}
class FuelProviderStatisticsLoading extends FuelProviderStatisticsState {}
class FuelProviderStatisticsLoaded extends FuelProviderStatisticsState {
  final FuelProviderStatisticsEntity statistics;
  FuelProviderStatisticsLoaded(this.statistics);
}
class FuelProviderStatisticsError extends FuelProviderStatisticsState {
  final String message;
  FuelProviderStatisticsError(this.message);
}
