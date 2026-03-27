import 'package:car_care/features/maintenance/user_statistics/domain/repositories/i_statistics.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/cubit/statistics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';






class StatisticsCubit extends Cubit<StatisticsState> {
  final IStatisticsRepository _repository;
  StatisticsCubit(this._repository) : super(StatisticsInitial());


  Future<void> fetchStatistics() async {
    emit(StatisticsLoading());
    final result = await _repository.statistics();
    result.fold(
      (failure) => emit(StatisticsError(failure.message)),
      (statistics) => emit(StatisticsLoaded(statistics)),
    );
  }
}