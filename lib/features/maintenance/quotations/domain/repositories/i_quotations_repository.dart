import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/quotations_entity.dart';

abstract class IQuotationsRepository {

  Future<Either<Failure, QuotationsEntity>> quotations(Map<String, dynamic> params);

}
