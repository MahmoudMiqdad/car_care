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
        success: json["success"] as bool? ?? true,
        data: MaintenanceRequestDetailsData.fromJson(
          json["data"] is Map<String, dynamic>
              ? json["data"] as Map<String, dynamic>
              : const {},
        ),
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
        id: json["id"] as int? ?? 0,
        description: json["description"]?.toString() ?? '',
        priority: json["priority"]?.toString() ?? '',
        priorityText: json["priority_text"]?.toString() ?? '',
        status: json["status"]?.toString() ?? '',
        statusText: json["status_text"]?.toString() ?? '',
        vehicle: json["vehicle"] is Map<String, dynamic>
            ? RequestVehicle.fromJson(json["vehicle"] as Map<String, dynamic>)
            : null,
        images: json["images"] is List
            ? (json["images"] as List)
                .whereType<Map<String, dynamic>>()
                .map(RequestImage.fromJson)
                .toList()
            : const [],
        // Confirmed backend example: quotations[].notes can be null; every
        // nested field below is now parsed leniently for the same reason.
        quotations: json["quotations"] is List
            ? (json["quotations"] as List)
                .whereType<Map<String, dynamic>>()
                .map(RequestQuotation.fromJson)
                .toList()
            : const [],
        preferredDate: json["preferred_date"] != null
            ? DateTime.tryParse(json["preferred_date"].toString())
            : null,
        createdAt: json["created_at"]?.toString(),
        createdAgo: json["created_ago"]?.toString(),
        canCancel: json["can_cancel"] as bool? ?? false,
        assignedTechnician: json["assigned_technician"] is Map<String, dynamic>
            ? AssignedTechnician.fromJson(
                json["assigned_technician"] as Map<String, dynamic>)
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
        id: json["id"] as int? ?? 0,
        brand: json["brand"]?.toString(),
        model: json["model"]?.toString(),
        year: json["year"]?.toString(),
        plateNumber: json["plate_number"]?.toString(),
        currentKm: json["current_km"] as int?,
        image: json["image"]?.toString(),
        imagePath: json["image_path"]?.toString(),
      );
}

class RequestImage {
  final int id;
  final String url;

  RequestImage({required this.id, required this.url});

  factory RequestImage.fromJson(Map<String, dynamic> json) => RequestImage(
        id: json["id"] as int? ?? 0,
        url: json["url"]?.toString() ?? '',
      );
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
        id: json["id"] as int? ?? 0,
        // price is a float column on the backend, so it may arrive as a
        // decimal — round() is safe for either an int or a double input.
        price: (json["price"] as num?)?.round() ?? 0,
        priceFormatted: json["price_formatted"]?.toString() ?? '',
        estimatedDays: json["estimated_days"] as int? ?? 0,
        notes: json["notes"]?.toString() ?? '',
        partsIncluded: json["parts_included"] as bool? ?? false,
        status: json["status"]?.toString() ?? '',
        statusText: json["status_text"]?.toString() ?? '',
        technician: json["technician"] is Map<String, dynamic>
            ? RequestTechnician.fromJson(
                json["technician"] as Map<String, dynamic>)
            : RequestTechnician.empty(),
        createdAt: json["created_at"]?.toString(),
        createdAgo: json["created_ago"]?.toString(),
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

  factory RequestTechnician.empty() => RequestTechnician(
        id: 0,
        name: '',
        phone: '',
        technicianProfile: RequestTechnicianProfile.empty(),
      );

  factory RequestTechnician.fromJson(Map<String, dynamic> json) =>
      RequestTechnician(
        id: json["id"] as int? ?? 0,
        name: json["name"]?.toString() ?? '',
        phone: json["phone"]?.toString() ?? '',
        technicianProfile: json["technician_profile"] is Map<String, dynamic>
            ? RequestTechnicianProfile.fromJson(
                json["technician_profile"] as Map<String, dynamic>)
            : RequestTechnicianProfile.empty(),
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

  factory RequestTechnicianProfile.empty() => RequestTechnicianProfile(
        specialization: '',
        experienceYears: 0,
      );

  factory RequestTechnicianProfile.fromJson(Map<String, dynamic> json) =>
      RequestTechnicianProfile(
        specialization: json["specialization"]?.toString() ?? '',
        experienceYears: json["experience_years"] as int? ?? 0,
        currentLocation: json["current_location"] is Map<String, dynamic>
            ? RequestCurrentLocation.fromJson(
                json["current_location"] as Map<String, dynamic>)
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
        id: json["id"] as int? ?? 0,
        name: json["name"]?.toString() ?? '',
        phone: json["phone"]?.toString() ?? '',
        specialization: json["specialization"]?.toString() ?? '',
        experienceYears: json["experience_years"] as int? ?? 0,
        hourlyRate: json["hourly_rate"]?.toString(),
        currentLocation: json["current_location"] is Map<String, dynamic>
            ? RequestCurrentLocation.fromJson(
                json["current_location"] as Map<String, dynamic>)
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
        lat: (json["lat"] as num?)?.toDouble() ?? 0,
        lng: (json["lng"] as num?)?.toDouble() ?? 0,
        updatedAt: json["updated_at"]?.toString() ?? '',
      );
}
