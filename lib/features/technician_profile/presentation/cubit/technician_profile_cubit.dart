import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/abstract/i_technician_profile_repository.dart';
import 'technician_profile_state.dart';

class TechnicianProfileCubit extends Cubit<TechnicianProfileState> {
  final ITechnicianProfileRepository _repository;

  TechnicianProfileCubit(this._repository) : super(TechnicianProfileInitial());

  // جلب بيانات الفني
  Future<void> getTechnicianProfile() async {
    emit(TechnicianProfileLoading());

    final result = await _repository.showProfile();

    result.fold(
      (failure) => emit(TechnicianProfileError(failure.message)),
      (profile) => emit(TechnicianProfileLoaded(profile)),
    );
  }

  // تحديث بيانات الفني
  Future<void> updateTechnicianProfile(Map<String, dynamic> params) async {
    emit(TechnicianProfileLoading());

    final result = await _repository.updatetechnicianprofile(params);

    result.fold(
      (failure) => emit(TechnicianProfileError(failure.message)),
      (profile) => emit(TechnicianProfileLoaded(profile)),
    );
  }

  // إضافة بيانات الفني لأول مرة
  Future<void> insertTechnicianProfile(Map<String, dynamic> params) async {
    emit(TechnicianProfileLoading());

    final result = await _repository.inserttechnicianprofile(params);

    result.fold(
      (failure) => emit(TechnicianProfileError(failure.message)),
      (profile) => emit(TechnicianProfileLoaded(profile)),
    );
  }
}