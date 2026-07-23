
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';

abstract class FuelProviderProfileState {}

class FuelProviderProfileInitial extends FuelProviderProfileState {}

class FuelProviderProfileLoading extends FuelProviderProfileState {}

class FuelProviderProfileLoaded extends FuelProviderProfileState {
  final FuelProviderProfileEntity profile;
  FuelProviderProfileLoaded(this.profile);
}

class FuelProviderAvailabilityUpdated extends FuelProviderProfileState {}

class FuelProviderPricesUpdated extends FuelProviderProfileState {}

class FuelProviderProfileError extends FuelProviderProfileState {
  final String message;
  FuelProviderProfileError(this.message);
}