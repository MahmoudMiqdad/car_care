import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/fuel_provider/provider_profile/data/data_sources/provider_profile_remote_data_source.dart';
import 'package:car_care/features/fuel_provider/provider_profile/data/models/fuel_provider_model.dart';
import 'package:car_care/features/fuel_provider/provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/features/fuel_provider/provider_profile/domain/repositories/i_provider_profile_repository.dart';

import 'package:dartz/dartz.dart';

class FuelProviderProfileRepositoryImpl
    implements IFuelProviderProfileRepository {
  final FuelProviderProfileRemoteDataSource _remote;

  FuelProviderProfileRepositoryImpl(this._remote);

  FuelProviderProfileEntity _map(FuelProviderProfileData? d) => FuelProviderProfileEntity(
        id: d?.id,
        companyName: d?.companyName,
        phone: d?.phone,
        city: d?.city,
        address: d?.address,
        latitude: d?.latitude,
        longitude: d?.longitude,
        fuelTypes: d?.fuelTypes,
        prices: d?.prices,
        isAvailable: d?.isAvailable,
        isVerified: d?.isVerified,
        createdAt: d?.createdAt,
        status: d?.status,
        rejectionReason: d?.rejectionReason,
      );

  @override
  Future<Either<Failure, FuelProviderProfileEntity>> addProfile(
      Map<String, dynamic> data) async {
    try {
      final res = await _remote.addProfile(data);
      return Right(_map(res.data));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FuelProviderProfileEntity>> myProfile() async {
    try {
      final res = await _remote.myProfile();
      return Right(_map(res.data));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAvailability(bool isAvailable) async {
    try {
      await _remote.updateAvailability(isAvailable);
      return const Right(unit);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePrices(Map<String, double> prices) async {
    try {
      await _remote.updatePrices(prices);
      return const Right(unit);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}