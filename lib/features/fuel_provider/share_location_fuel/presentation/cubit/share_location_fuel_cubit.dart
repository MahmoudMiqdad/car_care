import 'package:car_care/features/fuel_provider/share_location_fuel/domain/repositories/i_share_location_fuel_repository.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/presentation/cubit/share_location_fuel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareFuelProviderLocationCubit
    extends Cubit<ShareFuelProviderLocationState> {
  final IShareFuelProviderLocationRepository _repo;

  ShareFuelProviderLocationCubit(this._repo)
      : super(ShareFuelProviderLocationInitial());

  Future<void> shareLocation({
    required int orderId,
    required double lat,
    required double lng,
  }) async {
    emit(ShareFuelProviderLocationLoading());
    final res = await _repo.shareLocation(orderId: orderId, lat: lat, lng: lng);
    res.fold(
      (l) => emit(ShareFuelProviderLocationError(l.displayMessage)),
      (_) => emit(ShareFuelProviderLocationSuccess()),
    );
  }
}