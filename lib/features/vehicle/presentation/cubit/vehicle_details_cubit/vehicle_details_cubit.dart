import 'package:car_care/features/vehicle/domain/repositories/abstract/i_vehicle_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_details_state.dart';

class VehicleDetailsCubit extends Cubit<VehicleDetailsState> {
  VehicleDetailsCubit(this._vehicleRepository)
      : super(const VehicleDetailsInitial());

  final IVehicleRepository _vehicleRepository;

  Future<void> fetchVehicleDetails(int id) async {
    emit(const VehicleDetailsLoading());

    final result = await _vehicleRepository.getVehicleDetails(id);

    result.fold(
      (failure) => emit(VehicleDetailsError(failure.message)),
      (vehicle) => emit(VehicleDetailsLoaded(vehicle)),
    );
  }
}