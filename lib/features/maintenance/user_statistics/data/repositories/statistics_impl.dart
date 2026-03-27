import 'package:car_care/features/maintenance/user_statistics/data/data_sources/statistics_remote_data_source.dart';
import 'package:car_care/features/maintenance/user_statistics/data/models/statistics_model.dart';
import 'package:car_care/features/maintenance/user_statistics/domain/entities/statistics_entity.dart';
import 'package:car_care/features/maintenance/user_statistics/domain/repositories/i_statistics.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';


class StatisticsRepositoryImpl implements IStatisticsRepository {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepositoryImpl(this._remoteDataSource);

  StatisticsEntity _map(StatisticsModel model) {
    final data = model.data;
    return StatisticsEntity(
      success: model.success,
      data: StatisticsDataEntity(
        totalRequests: data.totalRequests,
        pendingRequests: data.pendingRequests,
        acceptedRequests: data.acceptedRequests,
        completedRequests: data.completedRequests,
        cancelledRequests: data.cancelledRequests,
      ),
    );
  }

  @override
  Future<Either<Failure, StatisticsEntity>> statistics() async {
    try {
      final model = await _remoteDataSource.statistics();
      return Right(_map(model));
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ أثناء جلب الإحصائيات'));
    }
  }
}