import 'package:car_care/features/vehicle/domain/repositories/i_vehicle_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fuel_logs_state.dart';

class FuelLogsCubit extends Cubit<FuelLogsState> {
  FuelLogsCubit(this._repo) : super(const FuelLogsInitial());

  final IVehicleRepository _repo;

  int _page = 1;
  static const int _perPage = 15;

  Future<void> fetch(int vehicleId) async {
    emit(const FuelLogsLoading());
    _page = 1;

    final result = await _repo.getFuelLogs(
      vehicleId,
      page: _page,
      perPage: _perPage,
    );

    result.fold(
      (failure) => emit(FuelLogsError(failure.displayMessage)),
      (page) => emit(
        page.items.isEmpty
            ? const FuelLogsEmpty()
            : FuelLogsLoaded(
                items: page.items,
                hasMore: page.hasMore,
                isLoadingMore: false,
              ),
      ),
    );
  }

  Future<void> loadMore(int vehicleId) async {
    final current = state;
    if (current is! FuelLogsLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    final nextPage = _page + 1;

    final result = await _repo.getFuelLogs(
      vehicleId,
      page: nextPage,
      perPage: _perPage,
    );

    result.fold(
      (failure) {
      
        emit(current.copyWith(isLoadingMore: false));
      },
      (page) {
        _page = nextPage;
        emit(
          current.copyWith(
            items: [...current.items, ...page.items],
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}
