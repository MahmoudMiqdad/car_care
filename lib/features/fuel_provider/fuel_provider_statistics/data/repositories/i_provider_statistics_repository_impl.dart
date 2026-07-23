import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/data/data_sources/provider_statistics_remote_data_source.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/repositories/i_provider_statistics_repository.dart';import 'package:dartz/dartz.dart';
class FuelProviderStatisticsRepositoryImpl
    implements IFuelProviderStatisticsRepository {
  final FuelProviderStatisticsRemoteDataSource _remote;
  FuelProviderStatisticsRepositoryImpl(this._remote);
 
  @override
  Future<Either<Failure, FuelProviderStatisticsEntity>> getStatistics() async {
    try {
      final res = await _remote.getStatistics();
      final d = res.data;
      return Right(FuelProviderStatisticsEntity(
        totalOrders: d?.totalOrders ?? 0,
        pendingOrders: d?.pendingOrders ?? 0,
        acceptedOrders: d?.acceptedOrders ?? 0,
        inProgressOrders: d?.inProgressOrders ?? 0,
        completedOrders: d?.completedOrders ?? 0,
        cancelledOrders: d?.cancelledOrders ?? 0,
        totalRevenue: d?.totalRevenue ?? 0,
      ));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}