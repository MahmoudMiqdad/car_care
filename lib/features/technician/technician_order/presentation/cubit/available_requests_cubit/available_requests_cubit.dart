
import 'package:car_care/features/technician/technician_order/domain/repositories/i_order_requests_repository.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/available_requests_cubit/available_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvailableRequestsCubit extends Cubit<AvailableRequestsState> {
  final ITechnicianOrderRepository _repository;

  AvailableRequestsCubit(this._repository) : super(AvailableRequestsInitial());

  Future<void> fetchAvailableRequests() async {
    emit(AvailableRequestsLoading());

    final result = await _repository.fetchAvailableRequests();

    result.fold(
      (failure) => emit(AvailableRequestsError(failure.message)),
      (requests) => emit(AvailableRequestsLoaded(requests)),
    );
  }
}