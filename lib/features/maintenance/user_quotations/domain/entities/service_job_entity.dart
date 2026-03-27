class ServiceJobEntity {
  final int maintenanceRequestId;
  final int quotationId;
  final int technicianId;
  final String status;
  final DateTime scheduledDate;
  final String notes;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  ServiceJobEntity({
    required this.maintenanceRequestId,
    required this.quotationId,
    required this.technicianId,
    required this.status,
    required this.scheduledDate,
    required this.notes,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
}