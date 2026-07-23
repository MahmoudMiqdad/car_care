// provider_profile_cubit.dart
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/repositories/i_provider_profile_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelProviderProfileCubit extends Cubit<FuelProviderProfileState> {
  final IFuelProviderProfileRepository _repo;

  FuelProviderProfileCubit(this._repo) : super(FuelProviderProfileInitial());

  FuelProviderProfileEntity? currentProfile;

  Future<void> addProfile(Map<String, dynamic> data) async {
    emit(FuelProviderProfileLoading());
    final res = await _repo.addProfile(data);
    res.fold(
      (l) => emit(FuelProviderProfileError(l.message)),
      (r) {
        currentProfile = r;
        emit(FuelProviderProfileLoaded(r));
      },
    );
  }

  Future<void> myProfile() async {
    emit(FuelProviderProfileLoading());
    final res = await _repo.myProfile();
    res.fold(
      (l) => emit(FuelProviderProfileError(l.message)),
      (r) {
        currentProfile = r;
        emit(FuelProviderProfileLoaded(r));
      },
    );
  }

  Future<void> updateAvailability(bool isAvailable) async {
    final res = await _repo.updateAvailability(isAvailable);
    res.fold(
      (l) => emit(FuelProviderProfileError(l.message)),
      (_) => emit(FuelProviderAvailabilityUpdated()),
    );
  }

  Future<void> updatePrices(Map<String, double> prices) async {
    final res = await _repo.updatePrices(prices);
    res.fold(
      (l) => emit(FuelProviderProfileError(l.message)),
      (_) => emit(FuelProviderPricesUpdated()),
    );
  }
}