
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/completed_requests_cubit/completed_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class CompletedRequestsCubit extends Cubit<CompletedRequestsState> {
  final IRequestsRepository _repository;
  CompletedRequestsCubit(this._repository) : super(CompletedRequestsInitial());

  Future<void> completedRequests() async {
    emit(CompletedRequestsLoading());
    final result = await _repository.completedRequests();
    result.fold(
      (failure) => emit(CompletedRequestsError(failure.message)),
      (response) => emit(CompletedRequestsLoaded(response)),
    );
  }
}