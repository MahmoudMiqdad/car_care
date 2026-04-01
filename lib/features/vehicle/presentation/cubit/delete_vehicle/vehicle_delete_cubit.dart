import 'package:bloc/bloc.dart';
import 'package:car_care/features/vehicle/domain/repositories/i_vehicle_repository.dart';
import 'vehicle_delete_state.dart';

class VehicleDeleteCubit extends Cubit<VehicleDeleteState> {
  VehicleDeleteCubit(this._repo) : super(const VehicleDeleteInitial());

  final IVehicleRepository _repo;

  Future<void> deleteVehicle(int id) async {
    emit(const VehicleDeleteLoading());

    final result = await _repo.deleteVehicle(id);

    result.fold(
      (failure) => emit(VehicleDeleteError(failure.message)),
      (_) => emit(const VehicleDeleteSuccess()),
    );
  }
}