import 'package:car_care/features/vehicle/domain/repositories/abstract/i_vehicle_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit(this._vehicleRepository) : super(const VehicleInitial());

  final IVehicleRepository _vehicleRepository;

  Future<void> getAllVehicles() async {
    emit(const VehicleLoading());

    final result = await _vehicleRepository.getAllVehicles();

    result.fold(
      (failure) => emit(VehicleError(failure.message)),
      (vehicles) {
        if (vehicles.isEmpty) {
          emit(const VehicleEmpty());
        } else {
          emit(VehicleLoaded(vehicles));
        }
      },
    );
  }

}