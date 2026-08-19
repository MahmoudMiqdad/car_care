
import 'package:car_care/features/provider_invoices/data/models/invoice_item_model.dart';
import 'package:car_care/features/provider_invoices/data/models/provider_invoice_model.dart';

class ProviderInvoiceDetailsModel extends ProviderInvoiceModel {
  final List<InvoiceItemModel> items;

  ProviderInvoiceDetailsModel({
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

  factory ProviderInvoiceDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProviderInvoiceDetailsModel(items: []);

    return ProviderInvoiceDetailsModel(
      id: json["id"],
      invoiceNumber: json["invoice_number"],
      providerType: json["provider_type"],
      periodStart: json["period_start"],
      periodEnd: json["period_end"],
      subtotal: json["subtotal"],
      commissionTotal: json["commission_total"],
      subscriptionTotal: json["subscription_total"],
      totalAmount: json["total_amount"],
      status: json["status"],
      effectiveStatus: json["effective_status"],
      issuedAt: json["issued_at"] != null
          ? DateTime.tryParse(json["issued_at"])
          : null,
      dueAt: json["due_at"] != null ? DateTime.tryParse(json["due_at"]) : null,
      paidAt:
          json["paid_at"] != null ? DateTime.tryParse(json["paid_at"]) : null,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      items: json["items"] != null
          ? List<InvoiceItemModel>.from(
              json["items"].map((x) => InvoiceItemModel.fromJson(x)))
          : [],
    );
  }
}