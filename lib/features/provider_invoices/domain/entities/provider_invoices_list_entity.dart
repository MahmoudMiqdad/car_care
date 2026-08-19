
import 'package:car_care/features/provider_invoices/domain/entities/meta_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_entity.dart';

class ProviderInvoicesListEntity {
  final bool? success;
  final List<ProviderInvoiceEntity> data;
  final MetaEntity? meta;

  ProviderInvoicesListEntity({
    this.success,
    required this.data,
    this.meta,
  });
}