class InvoiceItemModel {
  final int? id;
  final String? itemType;
  final String? sourceType;
  final int? sourceId;
  final String? description;
  final num? amount;

  InvoiceItemModel({
    this.id,
    this.itemType,
    this.sourceType,
    this.sourceId,
    this.description,
    this.amount,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return InvoiceItemModel();

    return InvoiceItemModel(
      id: json["id"],
      itemType: json["item_type"],
      sourceType: json["source_type"],
      sourceId: json["source_id"],
      description: json["description"],
      amount: json["amount"],
    );
  }
}