

class MaintenanceRequestDetailsEntity {
  final bool success;
  final MaintenanceRequestDetailsDataEntity data;

  MaintenanceRequestDetailsEntity({
    required this.success,
    required this.data,
  });
}

class MaintenanceRequestDetailsDataEntity {
  final int id;
  final String description;
  final String priority;
  final String priorityText;
  final String status;
  final String statusText;
  final RequestVehicleEntity? vehicle;
  final List<RequestImageEntity> images;
  final List<RequestQuotationEntity> quotations;
  final DateTime? preferredDate;
  final String? createdAt;
  final String? createdAgo;
  final bool canCancel;
  final AssignedTechnicianEntity? assignedTechnician;

  MaintenanceRequestDetailsDataEntity({
    required this.id,
    required this.description,
    required this.priority,
    required this.priorityText,
    required this.status,
    required this.statusText,
    this.vehicle,
    required this.images,
    required this.quotations,
    this.preferredDate,
    this.createdAt,
    this.createdAgo,
    required this.canCancel,
    this.assignedTechnician,
  });
}

class RequestVehicleEntity {
  final int id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;

  /// Raw `image` / `image_path` from the API; resolve with resolveMediaUrl().
  final String? image;
  final String? imagePath;

  RequestVehicleEntity({
    required this.id,
    this.brand,
    this.model,
    this.year,
    this.plateNumber,
    this.currentKm,
    this.image,
    this.imagePath,
  });
}

class RequestImageEntity {
  final int id;
  final String url;

  RequestImageEntity({required this.id, required this.url});
}

class RequestQuotationEntity {
  final int id;
  final int price;
  final String priceFormatted;
  final int estimatedDays;
  final String notes;
  final bool partsIncluded;
  final String status;
  final String statusText;
  final RequestTechnicianEntity technician;
  final String? createdAt;
  final String? createdAgo;

  RequestQuotationEntity({
    required this.id,
    required this.price,
    required this.priceFormatted,
    required this.estimatedDays,
    required this.notes,
    required this.partsIncluded,
    required this.status,
    required this.statusText,
    required this.technician,
    this.createdAt,
    this.createdAgo,
  });
}

class RequestTechnicianEntity {
  final int id;
  final String name;
  final String phone;
  final RequestTechnicianProfileEntity technicianProfile;

  RequestTechnicianEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.technicianProfile,
  });
}

class RequestTechnicianProfileEntity {
  final String specialization;
  final int experienceYears;
  final RequestCurrentLocationEntity? currentLocation;

  RequestTechnicianProfileEntity({
    required this.specialization,
    required this.experienceYears,
    this.currentLocation,
  });
}

class AssignedTechnicianEntity {
  final int id;
  final String name;
  final String phone;
  final String specialization;
  final int experienceYears;
  final String? hourlyRate;
  final RequestCurrentLocationEntity? currentLocation;

  AssignedTechnicianEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.specialization,
    required this.experienceYears,
    this.hourlyRate,
    this.currentLocation,
  });
}

class RequestCurrentLocationEntity {
  final double lat;
  final double lng;
  final String updatedAt;

  RequestCurrentLocationEntity({
    required this.lat,
    required this.lng,
    required this.updatedAt,
  });
}