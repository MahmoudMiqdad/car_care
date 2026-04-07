import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/features/vehicle/domain/repositories/i_vehicle_repository.dart';
import 'maintenance_history_state.dart';

class MaintenanceHistoryCubit extends Cubit<MaintenanceHistoryState> {
  MaintenanceHistoryCubit(this._repo) : super(const MaintenanceHistoryInitial());

  final IVehicleRepository _repo;

  Future<void> fetch(int vehicleId) async {
    emit(const MaintenanceHistoryLoading());

    final result = await _repo.getMaintenanceHistory(vehicleId);

    result.fold(
      (failure) => emit(MaintenanceHistoryFailure(failure.message)),
      (items) => emit(MaintenanceHistorySuccess(items)),
    );
  }
}