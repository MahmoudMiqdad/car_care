import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/features/maintenance/user_quotations/data/data_sources/quotations_remote_data_source.dart';

import 'package:car_care/features/maintenance/user_quotations/domain/entities/accept_quotations_entity.dart';

import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotations_entity.dart';

import 'package:car_care/features/maintenance/user_quotations/domain/mappers/quotation_mappers.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/repositories/i_quotations_repository.dart';
import 'package:dartz/dartz.dart';

class QuotationsRepositoryImpl implements IQuotationsRepository {
  final QuotationsRemoteDataSource _remoteDataSource;

  QuotationsRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, QuotationsEntity>> fetchQuotations(String requestId) async {
    try {
      final model = await _remoteDataSource.fetchQuotations(requestId);
      return Right(mapQuotations(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, QuotationsEntity>> fetchAcceptedQuotations(String requestId) async {
    try {
      final model = await _remoteDataSource.fetchAcceptedQuotations(requestId);
      return Right(mapQuotations(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, AcceptQuotationEntity>> acceptQuotation(
    Map<String, dynamic> data,
    String requestId,
    String quotationId,
  ) async {
    try {
      final model = await _remoteDataSource.acceptQuotation(data, requestId, quotationId);
      return Right(mapAccept(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, AcceptQuotationEntity>> rejectQuotation(
    String reason,
    String quotationId,
  ) async {
    try {
      final model = await _remoteDataSource.rejectQuotation(reason, quotationId);
      return Right(mapAccept(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}