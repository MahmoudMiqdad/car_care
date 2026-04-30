import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/i_car_wash_booking_repository.dart';
import 'car_wash_booking_state.dart';

class CarWashBookingCubit extends Cubit<CarWashBookingState> {
  CarWashBookingCubit(this._repo) : super(CarWashBookingInitial());
  final ICarWashBookingRepository _repo;

  Future<void> createBooking({
    required int vehicleId,
    required int carWasherId,
    required String scheduledAt,
    required String serviceType,
    String? notes,
  }) async {
    emit(CarWashBookingSubmitting());

    final result = await _repo.createBooking(
      vehicleId: vehicleId,
      carWasherId: carWasherId,
      scheduledAt: scheduledAt,
      serviceType: serviceType,
      notes: notes,
    );

    result.fold(
      (f) => emit(CarWashBookingError(f.message)),
      (data) => emit(CarWashBookingSuccess(data)),
    );
  }
}