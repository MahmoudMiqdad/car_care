import 'dart:typed_data';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/domain/repositories/abstract/i_vehicle_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_add_state.dart';

class VehicleAddCubit extends Cubit<VehicleAddState> {
  VehicleAddCubit(this._vehicleRepository) : super(const VehicleAddInitial());

  final IVehicleRepository _vehicleRepository;

  Future<void> addVehicle({
    required String brand,
    required String model,
    required String year,
    required String plateNumber,
    required String currentKm,
    required Uint8List imageBytes,//اذا حطينا فايل  ما رح تنحفظ الصورة بالكاش و رح يطلع خطأ
    required String imageFileName,
  }) async {
    emit(const VehicleAddLoading());

    final params = <String, dynamic>{
      'brand': brand.trim(),
      'model': model.trim(),
      'year': year.trim(),
      'plate_number': plateNumber.trim(),
      'current_km': currentKm.trim(),
      'image_bytes': imageBytes,
      'image_name': imageFileName,
    };

    final result = await _vehicleRepository.addVehicle(params);

    result.fold(
      (failure) => emit(VehicleAddError(failure.message)),
      (VehicleEntity vehicle) => emit(VehicleAddSuccess(vehicle)),
    );
  }
}