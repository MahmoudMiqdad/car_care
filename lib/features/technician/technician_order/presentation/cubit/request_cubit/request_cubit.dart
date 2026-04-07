
import 'package:car_care/features/technician/technician_order/domain/repositories/i_order_requests_repository.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RequestCubit extends Cubit<RequestState> {
  final ITechnicianOrderRepository _repository;

  RequestCubit(this._repository) : super(RequestInitial());

  Future<void> fetchRequest(String idRequest) async {
    emit(RequestLoading());

    final result = await _repository.fetchRequest(idRequest);

    result.fold(
      (failure) => emit(RequestError(failure.message)),
      (request) => emit(RequestLoaded(request)),
    );
  }
}