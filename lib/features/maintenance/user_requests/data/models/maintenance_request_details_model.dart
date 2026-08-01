// maintenance_request_details_model.dart

class MaintenanceRequestDetailsModel {
  final bool success;
  final MaintenanceRequestDetailsData data;

  MaintenanceRequestDetailsModel({
    required this.success,
    required this.data,
  });

  factory MaintenanceRequestDetailsModel.fromJson(Map<String, dynamic> json) =>
      MaintenanceRequestDetailsModel(
        success: json["success"],
        data: MaintenanceRequestDetailsData.fromJson(json["data"]),
      );
}

class MaintenanceRequestDetailsData {
  final int id;
  final String description;
  final String priority;
  final String priorityText;
  final String status;
  final String statusText;
  final RequestVehicle? vehicle;
  final List<RequestImage> images;
  final List<RequestQuotation> quotations;
  final DateTime? preferredDate;
  final String? createdAt;
  final String? createdAgo;
  final bool canCancel;
  final AssignedTechnician? assignedTechnician;

  MaintenanceRequestDetailsData({
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

  factory MaintenanceRequestDetailsData.fromJson(Map<String, dynamic> json) =>
      MaintenanceRequestDetailsData(
        id: json["id"],
        description: json["description"],
        priority: json["priority"],
        priorityText: json["priority_text"],
        status: json["status"],
        statusText: json["status_text"],
        vehicle: json["vehicle"] != null
            ? RequestVehicle.fromJson(json["vehicle"])
            : null,
        images: (json["images"] as List)
            .map((e) => RequestImage.fromJson(e))
            .toList(),
        quotations: (json["quotations"] as List)
            .map((e) => RequestQuotation.fromJson(e))
            .toList(),
        preferredDate: json["preferred_date"] != null
            ? DateTime.parse(json["preferred_date"])
            : null,
        createdAt: json["created_at"],
        createdAgo: json["created_ago"],
        canCancel: json["can_cancel"] ?? false,
        assignedTechnician: json["assigned_technician"] != null
            ? AssignedTechnician.fromJson(json["assigned_technician"])
            : null,
      );
}

class RequestVehicle {
  final int id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;
  final String? image;
  final String? imagePath;

  RequestVehicle({
    required this.id,
    this.brand,
    this.model,
    this.year,
    this.image,
    this.plateNumber,
    this.currentKm,
    this.imagePath,
  });

  factory RequestVehicle.fromJson(Map<String, dynamic> json) => RequestVehicle(
        id: json["id"],
        brand: json["brand"],
        model: json["model"],
        year: json["year"],
        plateNumber: json["plate_number"],
        currentKm: json["current_km"],
        image: json["image"]?.toString(),
        imagePath: json["image_path"]?.toString(),
      );
}

class RequestImage {
  final int id;
  final String url;

  RequestImage({required this.id, required this.url});

  factory RequestImage.fromJson(Map<String, dynamic> json) =>
      RequestImage(id: json["id"], url: json["url"]);
}

class RequestQuotation {
  final int id;
  final int price;
  final String priceFormatted;
  final int estimatedDays;
  final String notes;
  final bool partsIncluded;
  final String status;
  final String statusText;
  final RequestTechnician technician;
  final String? createdAt;
  final String? createdAgo;

  RequestQuotation({
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

  factory RequestQuotation.fromJson(Map<String, dynamic> json) =>
      RequestQuotation(
        id: json["id"],
        price: json["price"],
        priceFormatted: json["price_formatted"],
        estimatedDays: json["estimated_days"],
        notes: json["notes"],
        partsIncluded: json["parts_included"],
        status: json["status"],
        statusText: json["status_text"],
        technician: RequestTechnician.fromJson(json["technician"]),
        createdAt: json["created_at"],
        createdAgo: json["created_ago"],
      );
}

class RequestTechnician {
  final int id;
  final String name;
  final String phone;
  final RequestTechnicianProfile technicianProfile;

  RequestTechnician({
    required this.id,
    required this.name,
    required this.phone,
    required this.technicianProfile,
  });

  factory RequestTechnician.fromJson(Map<String, dynamic> json) =>
      RequestTechnician(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        technicianProfile:
            RequestTechnicianProfile.fromJson(json["technician_profile"]),
      );
}

class RequestTechnicianProfile {
  final String specialization;
  final int experienceYears;
  final RequestCurrentLocation? currentLocation;

  RequestTechnicianProfile({
    required this.specialization,
    required this.experienceYears,
    this.currentLocation,
  });

  factory RequestTechnicianProfile.fromJson(Map<String, dynamic> json) =>
      RequestTechnicianProfile(
        specialization: json["specialization"],
        experienceYears: json["experience_years"],
        currentLocation: json["current_location"] != null
            ? RequestCurrentLocation.fromJson(json["current_location"])
            : null,
      );
}

class AssignedTechnician {
  final int id;
  final String name;
  final String phone;
  final String specialization;
  final int experienceYears;
  final String? hourlyRate;
  final RequestCurrentLocation? currentLocation;

  AssignedTechnician({
    required this.id,
    required this.name,
    required this.phone,
    required this.specialization,
    required this.experienceYears,
    this.hourlyRate,
    this.currentLocation,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) =>
      AssignedTechnician(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        specialization: json["specialization"],
        experienceYears: json["experience_years"],
        hourlyRate: json["hourly_rate"],
        currentLocation: json["current_location"] != null
            ? RequestCurrentLocation.fromJson(json["current_location"])
            : null,
      );
}

class RequestCurrentLocation {
  final double lat;
  final double lng;
  final String updatedAt;

  RequestCurrentLocation({
    required this.lat,
    required this.lng,
    required this.updatedAt,
  });

  factory RequestCurrentLocation.fromJson(Map<String, dynamic> json) =>
      RequestCurrentLocation(
        lat: (json["lat"] as num).toDouble(),
        lng: (json["lng"] as num).toDouble(),
        updatedAt: json["updated_at"],
      );
}