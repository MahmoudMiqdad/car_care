import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/add_maintenance_request_cubit/add_maintenance_request_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddMaintenanceRequestCubit extends Cubit<AddMaintenanceRequestState> {
  final IRequestsRepository _repository;
  AddMaintenanceRequestCubit(this._repository) : super(AddMaintenanceRequestInitial());

  Future<void> addRequest(FormData formData) async {  // ← FormData بدلاً من Map
    emit(AddMaintenanceRequestLoading());
    final result = await _repository.addMaintenanceRequest(formData);
    result.fold(
      (failure) => emit(AddMaintenanceRequestError(failure.message)),
      (response) => emit(AddMaintenanceRequestSuccess(response)),
    );
  }
}