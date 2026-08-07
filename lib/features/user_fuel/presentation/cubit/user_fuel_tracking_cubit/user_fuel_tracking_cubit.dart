import 'dart:async';
import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_tracking_cubit/user_fuel_tracking_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class UserFuelTrackingCubit extends Cubit<UserFuelTrackingState> {
  final IUserFuelRepository _repo;
  Timer? _timer;

  UserFuelTrackingCubit(this._repo) : super(UserFuelTrackingLoading());

  Future<void> loadTracking(int orderId) async {
    await _fetch(orderId);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetch(orderId);
    });
  }

  Future<void> _fetch(int orderId) async {
    final res = await _repo.trackOrder(orderId);
    res.fold(
      (l) => emit(UserFuelTrackingError(l.displayMessage)),
      (r) {
        final loc = r.currentLocation;
        final liveLocation = (loc?.latitude != null && loc?.longitude != null)
            ? LatLng(loc!.latitude!, loc.longitude!)
            : null;
        emit(UserFuelTrackingLoaded(r, liveLocation: liveLocation));
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}