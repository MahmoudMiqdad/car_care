import 'package:car_care/features/technician/technician_quotations/domain/entities/technician_quotations_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';


abstract class ITechnicianQuotationsRepository {
  Future<Either<Failure, SubmitQuotationEntity>> submitQuotation(
    Map<String, dynamic> data,
    String requestId,
  );
}