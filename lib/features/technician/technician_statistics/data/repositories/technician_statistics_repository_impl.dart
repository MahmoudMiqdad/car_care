import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/errors/excptions.dart';
import '../../domain/entities/technician_statistics_entity.dart';
import '../../domain/repositories/i_technician_statistics_repository.dart';
import '../data_sources/technician_statistics_remote_data_source.dart';
import '../models/statistics_technician_model.dart';

class TechnicianStatisticsRepositoryImpl
    implements ITechnicianStatisticsRepository {
  final TechnicianStatisticsRemoteDataSource _remoteDataSource;

  TechnicianStatisticsRepositoryImpl(this._remoteDataSource);

  TechnicianStatisticsEntity _map(StatisticsTechnicianModel model) {
    final data = model.data;

    return TechnicianStatisticsEntity(
      success: model.success,
      data: TechnicianStatisticsDataEntity(
        totalJobs: data.totalJobs,
        assignedJobs: data.assignedJobs,
        inProgressJobs: data.inProgressJobs,
        completedJobs: data.completedJobs,
        totalQuotations: data.totalQuotations,
        pendingQuotations: data.pendingQuotations,
        acceptedQuotations: data.acceptedQuotations,
        totalEarnings: data.totalEarnings,
        averageRating: data.averageRating,
        totalRatings: data.totalRatings,
      ),
    );
  }

  @override
  Future<Either<Failure, TechnicianStatisticsEntity>> getStatistics() async {
    try {
      final model = await _remoteDataSource.statisticsTechnician();
      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
