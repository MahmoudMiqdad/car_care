class SubmitQuotationEntity {
  final bool success;
  final String message;
  final SubmitQuotationDataEntity data;

  const SubmitQuotationEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}

class SubmitQuotationDataEntity {
  final int id;
  final int maintenanceRequestId;
  final int price;
  final String priceFormatted;
  final int estimatedDays;
  final bool partsIncluded;
  final String notes;
  final String status;
  final String statusText;
  final DateTime createdAt;
  final String createdAgo;

  const SubmitQuotationDataEntity({
    required this.id,
    required this.maintenanceRequestId,
    required this.price,
    required this.priceFormatted,
    required this.estimatedDays,
    required this.partsIncluded,
    required this.notes,
    required this.status,
    required this.statusText,
    required this.createdAt,
    required this.createdAgo,
  });
}