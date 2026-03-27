import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/pending_requests_cubit/pending_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class PendingRequestsCubit extends Cubit<PendingRequestsState> {
  final IRequestsRepository _repository;
  PendingRequestsCubit(this._repository) : super(PendingRequestsInitial());

  Future<void> pendingRequests() async {
    emit(PendingRequestsLoading());
    final result = await _repository.pendingRequests();
    result.fold(
      (failure) => emit(PendingRequestsError(failure.message)),
      (response) => emit(PendingRequestsLoaded(response)),
    );
  }
}