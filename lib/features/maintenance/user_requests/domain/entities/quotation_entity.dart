class QuotationEntity {
  final int id;
  final String technicianName;
  final double price;
  final String status;
  final String notes;
  final String createdAt;

  QuotationEntity({
    required this.id,
    required this.technicianName,
    required this.price,
    required this.status,
    required this.notes,
    required this.createdAt,
  });
}