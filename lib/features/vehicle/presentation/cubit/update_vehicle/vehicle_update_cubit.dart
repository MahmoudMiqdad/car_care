import 'dart:typed_data';

import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/domain/repositories/i_vehicle_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'vehicle_update_state.dart';

class VehicleUpdateCubit extends Cubit<VehicleUpdateState> {
  VehicleUpdateCubit(this._repo) : super(const VehicleUpdateInitial());

  final IVehicleRepository _repo;

  Future<void> updateVehicle({
    required int id,
    required Map<String, String> changedFields,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    emit(const VehicleUpdateLoading());

    final params = <String, dynamic>{...changedFields};

    if (imageBytes != null && imageName != null) {
      params['image_bytes'] = imageBytes;
      params['image_name'] = imageName;
    }

    final result = await _repo.updateVehicle(id: id, params: params);

    result.fold(
      (failure) => emit(VehicleUpdateError(failure.displayMessage)),
      (VehicleEntity vehicle) => emit(VehicleUpdateSuccess(vehicle)),
    );
  }
}
