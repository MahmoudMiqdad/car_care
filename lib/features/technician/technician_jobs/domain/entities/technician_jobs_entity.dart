class TechnicianJobsEntity {
  final bool success;
  final List<JobEntity> jobs;

  const TechnicianJobsEntity({
    required this.success,
    required this.jobs,
  });
}

class JobEntity {
  final int id;
  final String status;
  final DateTime? scheduledDate;
  final String notes;

  final int? maintenanceRequestId;
  final String description;
  final String priority;
  final String customerName;
  final String customerPhone;
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleYear;
  final String plateNumber;

  final String? quotationPrice;
  final int? estimatedDays;

  const JobEntity({
    required this.id,
    required this.status,
    required this.scheduledDate,
    required this.notes,
    this.maintenanceRequestId,
    this.description = '',
    this.priority = '',
    this.customerName = '',
    this.customerPhone = '',
    this.vehicleBrand = '',
    this.vehicleModel = '',
    this.vehicleYear = '',
    this.plateNumber = '',
    this.quotationPrice,
    this.estimatedDays,
  });

  String get vehicleLabel {
    final parts = [vehicleBrand, vehicleModel, vehicleYear]
        .where((p) => p.isNotEmpty)
        .join(' ');
    return parts.isEmpty ? '-' : parts;
  }
}
