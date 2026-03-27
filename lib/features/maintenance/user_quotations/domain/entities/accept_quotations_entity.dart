import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/service_job_entity.dart';

class AcceptQuotationEntity {
  final bool success;
  final String message;
  final AcceptQuotationDataEntity data;

  AcceptQuotationEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}

class AcceptQuotationDataEntity {
  final QuotationEntity quotation;
  final ServiceJobEntity serviceJob;

  AcceptQuotationDataEntity({
    required this.quotation,
    required this.serviceJob,
  });
}