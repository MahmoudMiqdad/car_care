
import 'package:car_care/features/technician/technician_requests/domain/repositories/i_technician_requests_repository.dart';
import 'package:car_care/features/technician/technician_requests/presentation/cubit/request_cubit/request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RequestCubit extends Cubit<RequestState> {
  final ITechnicianRequestsRepository _repository;

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