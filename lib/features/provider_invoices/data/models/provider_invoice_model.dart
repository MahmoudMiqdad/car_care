class ProviderInvoiceModel {
  final int? id;
  final String? invoiceNumber;
  final String? providerType;
  final String? periodStart;
  final String? periodEnd;
  final num? subtotal;
  final num? commissionTotal;
  final num? subscriptionTotal;
  final num? totalAmount;
  final String? status;
  final String? effectiveStatus;
  final DateTime? issuedAt;
  final DateTime? dueAt;
  final DateTime? paidAt;
  final DateTime? createdAt;

  ProviderInvoiceModel({
    this.id,
    this.invoiceNumber,
    this.providerType,
    this.periodStart,
    this.periodEnd,
    this.subtotal,
    this.commissionTotal,
    this.subscriptionTotal,
    this.totalAmount,
    this.status,
    this.effectiveStatus,
    this.issuedAt,
    this.dueAt,
    this.paidAt,
    this.createdAt,
  });

  factory ProviderInvoiceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProviderInvoiceModel();

    return ProviderInvoiceModel(
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
    );
  }
}