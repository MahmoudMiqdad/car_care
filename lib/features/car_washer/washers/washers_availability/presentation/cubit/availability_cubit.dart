import 'package:car_care/features/car_washer/washers/washers_availability/domain/repositories/i_availability_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'availability_state.dart';

class AvailabilityCubit extends Cubit<AvailabilityState> {
  AvailabilityCubit(this._repository) : super(const AvailabilityInitial());

  final IAvailabilityRepository _repository;

  Future<void> changeAvailability(bool isAvailable) async {
    if (state is AvailabilityLoading) return;

    emit(const AvailabilityLoading());

    final result = await _repository.updateAvailability(isAvailable);

    result.fold(
      (failure) => emit(AvailabilityError(failure.displayMessage)),
      (data) => emit(AvailabilitySuccess(data.isAvailable)),
    );
  }
}
