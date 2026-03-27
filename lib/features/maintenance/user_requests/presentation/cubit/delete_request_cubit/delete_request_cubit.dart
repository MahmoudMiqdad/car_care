import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/delete_request_cubit/delete_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class DeleteRequestCubit extends Cubit<DeleteRequestState> {
  final IRequestsRepository _repository;
  DeleteRequestCubit(this._repository) : super(DeleteRequestInitial());

  Future<void> deleteRequest(String id) async {
    emit(DeleteRequestLoading());
    final result = await _repository.deleteRequest(id);
    result.fold(
      (failure) => emit(DeleteRequestError(failure.message)),
      (request) => emit(DeleteRequestSuccess(request)),
    );
  }
}