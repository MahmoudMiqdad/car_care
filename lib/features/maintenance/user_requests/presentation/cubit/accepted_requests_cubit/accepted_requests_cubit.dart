import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/accepted_requests_cubit/accepted_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class AcceptedRequestsCubit extends Cubit<AcceptedRequestsState> {
  final IRequestsRepository _repository;
  AcceptedRequestsCubit(this._repository) : super(AcceptedRequestsInitial());

  Future<void> acceptedRequests() async {
    emit(AcceptedRequestsLoading());
    final result = await _repository.acceptedRequests();
    result.fold(
      (failure) => emit(AcceptedRequestsError(failure.message)),
      (response) => emit(AcceptedRequestsLoaded(response)),
    );
  }
}