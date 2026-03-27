import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_technician_statistics_repository.dart';
import 'technician_statistics_state.dart';

class TechnicianStatisticsCubit extends Cubit<TechnicianStatisticsState> {
  TechnicianStatisticsCubit(this._repository)
      : super(TechnicianStatisticsInitial());

  final ITechnicianStatisticsRepository _repository;

  Future<void> getStatistics() async {
    emit(TechnicianStatisticsLoading());

    final result = await _repository.getStatistics();

    result.fold(
      (failure) => emit(TechnicianStatisticsError(failure.message)),
      (data) => emit(TechnicianStatisticsLoaded(data)),
    );
  }
}