
import 'package:car_care/features/provider_invoices/data/models/invoice_item_model.dart';
import 'package:car_care/features/provider_invoices/data/models/provider_invoice_details_model.dart';
import 'package:car_care/features/provider_invoices/domain/entities/invoice_item_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_details_entity.dart';

InvoiceItemEntity _mapItem(InvoiceItemModel model) => InvoiceItemEntity(
      id: model.id,
      itemType: model.itemType,
      sourceType: model.sourceType,
      sourceId: model.sourceId,
      description: model.description,
      amount: model.amount,
    );

ProviderInvoiceDetailsEntity mapProviderInvoiceDetails(
    ProviderInvoiceDetailsModel model) {
  return ProviderInvoiceDetailsEntity(
    id: model.id,
    invoiceNumber: model.invoiceNumber,
    providerType: model.providerType,
    periodStart: model.periodStart,
    periodEnd: model.periodEnd,
    subtotal: model.subtotal,
    commissionTotal: model.commissionTotal,
    subscriptionTotal: model.subscriptionTotal,
    totalAmount: model.totalAmount,
    status: model.status,
    effectiveStatus: model.effectiveStatus,
    issuedAt: model.issuedAt,
    dueAt: model.dueAt,
    paidAt: model.paidAt,
    createdAt: model.createdAt,
    items: model.items.map(_mapItem).toList(),
  );
}