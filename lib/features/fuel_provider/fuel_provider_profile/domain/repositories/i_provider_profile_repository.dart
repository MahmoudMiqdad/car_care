import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IFuelProviderProfileRepository {
  Future<Either<Failure, FuelProviderProfileEntity>> addProfile(Map<String, dynamic> data);
  Future<Either<Failure, FuelProviderProfileEntity>> myProfile();
  Future<Either<Failure, Unit>> updateAvailability(bool isAvailable);
  Future<Either<Failure, Unit>> updatePrices(Map<String, double> prices);
}