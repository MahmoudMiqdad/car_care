class InvoiceItemEntity {
  final int? id;
  final String? itemType;
  final String? sourceType;
  final int? sourceId;
  final String? description;
  final num? amount;

  InvoiceItemEntity({
    this.id,
    this.itemType,
    this.sourceType,
    this.sourceId,
    this.description,
    this.amount,
  });
}