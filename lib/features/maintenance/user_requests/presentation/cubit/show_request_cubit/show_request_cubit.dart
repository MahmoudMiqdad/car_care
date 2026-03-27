
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show_request_cubit/show_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ShowRequestCubit extends Cubit<ShowRequestState> {
  final IRequestsRepository _repository;
  ShowRequestCubit(this._repository) : super(ShowRequestInitial());

  Future<void> fetchRequest(String id) async {
    emit(ShowRequestLoading());
    final result = await _repository.showRequest(id);
    result.fold(
      (failure) => emit(ShowRequestError(failure.message)),
      (request) => emit(ShowRequestLoaded(request)),
    );
  }
}