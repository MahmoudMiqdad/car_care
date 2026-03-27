import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/features/maintenance/user_rate_job/data/data_sources/rate_job_remote_data_source.dart';
import 'package:car_care/features/maintenance/user_rate_job/data/models/rate_model.dart';
import 'package:car_care/features/maintenance/user_rate_job/domain/entities/rate_job_entity.dart';
import 'package:car_care/features/maintenance/user_rate_job/domain/repositories/i_rate_job_repository.dart';
import 'package:dartz/dartz.dart';

class RateJobRepositoryImpl implements IRateJobRepository {
  final RateJobRemoteDataSource _remoteDataSource;

  RateJobRepositoryImpl(this._remoteDataSource);

  // mapper
  RateJobEntity _map(RateModel model) {
    return RateJobEntity(
      success: model.success,
      message: model.message,
      data: RateDataEntity(
        id: model.data.id,
        rating: model.data.rating,
        review: model.data.review,
      ),
    );
  }

  @override
  Future<Either<Failure, RateJobEntity>> rateJob(
    String review,
    String rating,
    String quotationId,
  ) async {
    try {
      final model = await _remoteDataSource.cancelRequest(
        review,
        rating,
        quotationId,
      );

      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}