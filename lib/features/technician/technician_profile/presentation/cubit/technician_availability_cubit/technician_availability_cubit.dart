import 'package:car_care/features/technician/technician_profile/domain/repositories/i_technician_profile_repository.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TechnicianAvailabilityCubit extends Cubit<TechnicianAvailabilityState> {
  TechnicianAvailabilityCubit(this._repository)
      : super(TechnicianAvailabilityInitial());

  final ITechnicianProfileRepository _repository;

  Future<void> changeAvailability(String isAvailable) async {
    emit(TechnicianAvailabilityLoading());

    final result = await _repository.changeAvailability(isAvailable);

    result.fold(
      (failure) => emit(TechnicianAvailabilityError(failure.message)),
      (data) => emit(TechnicianAvailabilitySuccess(data)),
    );
  }
}