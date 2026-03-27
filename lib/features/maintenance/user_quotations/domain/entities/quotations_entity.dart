import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';

class QuotationsEntity {
  final bool success;
  final List<QuotationEntity> data;

  QuotationsEntity({
    required this.success,
    required this.data,
  });
}