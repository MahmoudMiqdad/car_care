import '../../domain/entities/technician_statistics_entity.dart';

abstract class TechnicianStatisticsState {}

class TechnicianStatisticsInitial extends TechnicianStatisticsState {}

class TechnicianStatisticsLoading extends TechnicianStatisticsState {}

class TechnicianStatisticsLoaded extends TechnicianStatisticsState {
  final TechnicianStatisticsEntity data;

  TechnicianStatisticsLoaded(this.data);
}

class TechnicianStatisticsError extends TechnicianStatisticsState {
  final String message;

  TechnicianStatisticsError(this.message);
}