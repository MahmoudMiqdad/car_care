import 'package:car_care/features/maintenance/user_statistics/domain/entities/statistics_entity.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final StatisticsEntity statistics;
  StatisticsLoaded(this.statistics);
}

class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}