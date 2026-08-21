
import 'package:car_care/features/provider_invoices/domain/entities/invoice_item_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_entity.dart';

class ProviderInvoiceDetailsEntity extends ProviderInvoiceEntity {
  final List<InvoiceItemEntity> items;

  ProviderInvoiceDetailsEntity({
    super.id,
    super.invoiceNumber,
    super.providerType,
    super.periodStart,
    super.periodEnd,
    super.subtotal,
    super.commissionTotal,
    super.subscriptionTotal,
    super.totalAmount,
    super.status,
    super.effectiveStatus,
    super.issuedAt,
    super.dueAt,
    super.paidAt,
    super.createdAt,
    required this.items,
  });
}