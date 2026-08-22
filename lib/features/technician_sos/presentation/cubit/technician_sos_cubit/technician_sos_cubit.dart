import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';
import 'package:car_care/features/technician_sos/domain/repositories/i_technician_sos_repository.dart';
import 'package:car_care/features/technician_sos/presentation/technician_sos_request_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'technician_sos_state.dart';

class TechnicianSosCubit extends Cubit<TechnicianSosState> {
  final ITechnicianSosRepository _repo;

  TechnicianSosCubit(this._repo) : super(TechnicianInitial());

  SosRequestType _listType = SosRequestType.available;

  TechnicianSosEntity? _lastRequest;

  Future<void> getAvailableRequests() async {
    _listType = SosRequestType.available;
    emit(TechnicianLoading());
    final res = await _repo.getAvailableRequests();
    res.fold(
      (l) => emit(TechnicianError(l.displayMessage)),
      (r) => emit(TechnicianAvailableLoaded(r)),
    );
  }

  Future<void> myRequests() async {
    _listType = SosRequestType.myRequests;
    emit(TechnicianLoading());
    final res = await _repo.myRequests();
    res.fold(
      (l) => emit(TechnicianError(l.displayMessage)),
      (r) => emit(TechnicianAvailableLoaded(r)),
    );
  }

  Future<void> reloadList() {
    return _listType == SosRequestType.available
        ? getAvailableRequests()
        : myRequests();
  }

  Future<void> getRequest(int id) async {
    emit(TechnicianLoading());
    final res = await _repo.getRequest(id);
    res.fold((l) => emit(TechnicianError(l.displayMessage)), (r) {
      _lastRequest = r;
      emit(TechnicianRequestLoaded(r));
    });
  }

  Future<void> acceptRequest(int id) async {
    emit(TechnicianActionLoading(id));
    final res = await _repo.acceptRequest(id);
    await res.fold(
      (l) async =>
          emit(TechnicianActionError(l.displayMessage, request: _lastRequest)),
      (r) async {
        emit(TechnicianAccepted(r));
        final requestRes = await _repo.getRequest(id);
        requestRes.fold(
          (l) => emit(
            TechnicianActionError(l.displayMessage, request: _lastRequest),
          ),
          (updated) {
            _lastRequest = updated;
            emit(TechnicianRequestLoaded(updated));
          },
        );
      },
    );
  }

  Future<void> changeStatus(int sosId, String newStatus) async {
    emit(TechnicianActionLoading(sosId));

    final updateRes = await _repo.updateStatus(sosId, newStatus);

    await updateRes.fold(
      (l) async =>
          emit(TechnicianActionError(l.displayMessage, request: _lastRequest)),
      (updated) async {
        emit(TechnicianStatusChanged(updated));
        final requestRes = await _repo.getRequest(sosId);
        requestRes.fold(
          (l) => emit(
            TechnicianActionError(l.displayMessage, request: _lastRequest),
          ),
          (r) {
            _lastRequest = r;
            emit(TechnicianRequestLoaded(r));
          },
        );
      },
    );
  }

  Future<void> cancelResponse(int sosId, String reason) async {
    emit(TechnicianActionLoading(sosId));

    final res = await _repo.cancelResponse(sosId, reason);

    res.fold(
      (l) =>
          emit(TechnicianActionError(l.displayMessage, request: _lastRequest)),
      (message) => emit(TechnicianResponseCancelled(message)),
    );
  }
}
