import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/accept_quotations_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/quotations_entity.dart';

abstract class IQuotationsRepository {

  Future<Either<Failure, QuotationsEntity>> fetchQuotations(String requestId);

  Future<Either<Failure, QuotationsEntity>> fetchAcceptedQuotations(String requestId);

  Future<Either<Failure, AcceptQuotationEntity>> acceptQuotation(
    Map<String, dynamic> data,
    String requestId,
    String quotationId,
  );

  Future<Either<Failure, AcceptQuotationEntity>> rejectQuotation(
    String reason,
    String quotationId,
  );
}