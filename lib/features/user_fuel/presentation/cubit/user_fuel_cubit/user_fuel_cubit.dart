import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFuelCubit extends Cubit<UserFuelState> {
  final IUserFuelRepository _repo;

  UserFuelCubit(this._repo) : super(UserFuelInitial());

  Future<void> getAllOrders() async {
    emit(UserFuelLoading());
    final res = await _repo.getAllOrders();
    res.fold(
      (l) => emit(UserFuelError(l.displayMessage)),
      (r) => emit(UserFuelOrdersLoaded(r)),
    );
  }

  Future<void> getOrder(int id) async {
    emit(UserFuelLoading());
    final res = await _repo.getOrder(id);
    res.fold(
      (l) => emit(UserFuelError(l.displayMessage)),
      (r) => emit(UserFuelOrderLoaded(r)),
    );
  }

  Future<void> addEmergencyOrder(Map<String, dynamic> data) async {
    emit(UserFuelLoading());
    final res = await _repo.addEmergencyOrder(data);
    res.fold(
      (l) => emit(UserFuelError(l.displayMessage)),
      (r) => emit(UserFuelOrderCreated(r)),
    );
  }

  Future<void> cancelOrder(int id, String reason) async {
    emit(UserFuelLoading());
    final res = await _repo.cancelOrder(id, reason);
    res.fold(
      (l) => emit(UserFuelError(l.displayMessage)),
      (_) => emit(UserFuelOrderCancelled()),
    );
  }

  Future<void> trackOrder(int id) async {
    emit(UserFuelLoading());
    final res = await _repo.trackOrder(id);
    res.fold(
      (l) => emit(UserFuelError(l.displayMessage)),
      (r) => emit(UserFuelTrackLoaded(r)),
    );
  }
}