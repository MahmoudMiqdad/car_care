
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class CancelRequestCubit extends Cubit<CancelRequestState> {
  final IRequestsRepository _repository;
  CancelRequestCubit(this._repository) : super(CancelRequestInitial());


  Future<void> cancelRequest(String id, String reason) async {
    emit(CancelRequestLoading());
    final result = await _repository.cancelRequest(reason, id);
    result.fold(
      (failure) => emit(CancelRequestError(failure.message)),
      (request) => emit(CancelRequestSuccess(request)),
    );
  }
}