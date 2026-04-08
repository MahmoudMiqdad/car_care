import 'package:car_care/features/maintenance/user_requests/domain/request_status.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cubit/show_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';


class RequestsCubit extends Cubit<RequestsState> {
  final IRequestsRepository _repository;

  RequestsCubit(this._repository) : super(RequestsInitial());

  Future<void> fetch(RequestStatus status) async {
    emit(RequestsLoading());

    final result = await _getRequest(status);

    result.fold(
      (failure) => emit(RequestsError(failure.message)),
      (response) => emit(RequestsLoaded(response, status)),
    
       
    );
  
  }

  Future<dynamic> _getRequest(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return _repository.pendingRequests();
      case RequestStatus.accepted:
        return _repository.acceptedRequests();
      case RequestStatus.completed:
        return _repository.completedRequests();
      case RequestStatus.all:
        return _repository.getAllMaintenance();
    }
  }
}