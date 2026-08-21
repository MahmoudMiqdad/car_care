class ProviderInvoiceEntity {
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

  ProviderInvoiceEntity({
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
}
