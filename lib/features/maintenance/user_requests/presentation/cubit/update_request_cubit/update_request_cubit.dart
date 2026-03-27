import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/update_request_cubit/update_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateRequestCubit extends Cubit<UpdateRequestState> {
  final IRequestsRepository _repository;
  UpdateRequestCubit(this._repository) : super(UpdateRequestInitial());

  Future<void> updateRequest(String id, Map<String, dynamic> data) async {
    emit(UpdateRequestLoading());
    final result = await _repository.updateRequest(id, data);
    result.fold(
      (failure) => emit(UpdateRequestError(failure.message)),
      (request) => emit(UpdateRequestSuccess(request)),
    );
  }
}
