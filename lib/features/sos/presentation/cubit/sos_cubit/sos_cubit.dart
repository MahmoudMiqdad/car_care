import 'package:car_care/features/sos/domain/repositories/i_sos_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sos_state.dart';
class SosCubit extends Cubit<SosState> {
  final ISosRepository _repo;

  SosCubit(this._repo) : super(SosInitial());

  Future<void> createSos(Map<String, dynamic> data) async {
    emit(SosLoading());

    final result = await _repo.createSos(data);

    result.fold(
      // displayMessage surfaces backend 422 field errors instead of the
      // generic "بيانات الإدخال غير صحيحة".
      (l) => emit(SosError(l.displayMessage)),
      (r) => emit(SosCreated(r)),
    );
  }

  /// [silent] keeps the current list on screen during pull-to-refresh
  /// instead of swapping it for a full-page loader.
  Future<void> getAll({bool silent = false}) async {
    if (!silent) emit(SosLoading());

    final result = await _repo.getAll();

    result.fold(
      (l) => emit(SosError(l.displayMessage)),
      (r) => emit(SosListLoaded(r)),
    );
  }
    Future<void> getSosRequest(int id) async {
    emit(SosLoading());

    final result = await _repo.getSosRequest( id);

    result.fold(
      (l) => emit(SosError(l.message)),
      (r) => emit(SosRequestLoaded(r)),
    );
  }
 Future<void> cancelSos(int id, String cancellationReason) async {
  emit(SosLoading());

  final result = await _repo.cancelSos(id, cancellationReason);

  result.fold(
    (l) => emit(SosError(l.displayMessage)),
    (r) => emit(SosCansel(r)),
  );
}
}