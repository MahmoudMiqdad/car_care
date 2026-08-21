
import 'package:car_care/features/provider_invoices/data/models/meta_model.dart';
import 'package:car_care/features/provider_invoices/data/models/provider_invoice_model.dart';
import 'package:car_care/features/provider_invoices/data/models/provider_invoices_list_model.dart';
import 'package:car_care/features/provider_invoices/domain/entities/meta_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoices_list_entity.dart';

ProviderInvoiceEntity mapProviderInvoice(ProviderInvoiceModel model) {
  return ProviderInvoiceEntity(
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
  );
}

MetaEntity _mapMeta(MetaModel model) => MetaEntity(
      total: model.total,
      perPage: model.perPage,
      currentPage: model.currentPage,
    );

ProviderInvoicesListEntity mapProviderInvoicesList(
    ProviderInvoicesListModel model) {
  return ProviderInvoicesListEntity(
    success: model.success,
    data: model.data.map(mapProviderInvoice).toList(),
    meta: model.meta != null ? _mapMeta(model.meta!) : null,
  );
}