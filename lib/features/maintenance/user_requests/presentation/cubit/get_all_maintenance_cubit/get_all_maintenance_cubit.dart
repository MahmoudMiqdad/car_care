import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/get_all_maintenance_cubit/get_all_maintenance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class GetAllMaintenanceCubit extends Cubit<GetAllMaintenanceState> {
  final IRequestsRepository _repository;
  GetAllMaintenanceCubit(this._repository) : super(GetAllMaintenanceInitial());

  Future<void> fetchAllMaintenance() async {
    emit(GetAllMaintenanceLoading());
    final result = await _repository.getAllMaintenance();
    result.fold(
      (failure) => emit(GetAllMaintenanceError(failure.message)),
      (response) => emit(GetAllMaintenanceLoaded(response)),
    );
  }
}