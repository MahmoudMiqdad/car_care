
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/repositories/i_provider_statistics_repository.dart' show IFuelProviderStatisticsRepository;
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/cubit/provider_statistics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelProviderStatisticsCubit extends Cubit<FuelProviderStatisticsState> {
  final IFuelProviderStatisticsRepository _repo;

  FuelProviderStatisticsCubit(this._repo)
      : super(FuelProviderStatisticsInitial());

  Future<void> getStatistics() async {
    emit(FuelProviderStatisticsLoading());
    final res = await _repo.getStatistics();
    res.fold(
      (l) => emit(FuelProviderStatisticsError(l.message)),
      (r) => emit(FuelProviderStatisticsLoaded(r)),
    );
  }
}