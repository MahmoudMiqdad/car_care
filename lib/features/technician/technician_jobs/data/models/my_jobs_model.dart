
class MyJobsModel {
    bool success;
    Data data;

    MyJobsModel({
        required this.success,
        required this.data,
    });

    factory MyJobsModel.fromJson(Map<String, dynamic> json) => MyJobsModel(
        success: json["success"] as bool? ?? true,
        data: json["data"] is Map<String, dynamic>
            ? Data.fromJson(json["data"] as Map<String, dynamic>)
            // Some endpoints return a plain list instead of a paginator.
            : Data.fromList(json["data"] is List ? json["data"] as List : const []),
    );


}

class Data {
    int currentPage;
    List<Datum> data;
    int perPage;
    int total;

    Data({
        required this.currentPage,
        required this.data,
        required this.perPage,
        required this.total,
    });

    factory Data.fromList(List raw) => Data(
        currentPage: 1,
        data: raw
            .whereType<Map<String, dynamic>>()
            .map(Datum.fromJson)
            .toList(),
        perPage: raw.length,
        total: raw.length,
    );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"] as int? ?? 1,
        data: json["data"] is List
            ? (json["data"] as List)
                .whereType<Map<String, dynamic>>()
                .map(Datum.fromJson)
                .toList()
            : <Datum>[],
        perPage: json["per_page"] as int? ?? 0,
        total: json["total"] as int? ?? 0,
    );

}

class Datum {
    int id;
    int? maintenanceRequestId;
    int? quotationId;
    int? technicianId;
    String status;
    DateTime? scheduledDate;
    String notes;
    DateTime? startedAt;
    DateTime? completedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    MaintenanceRequest? maintenanceRequest;
    Quotation? quotation;

    Datum({
        required this.id,
        required this.maintenanceRequestId,
        required this.quotationId,
        required this.technicianId,
        required this.status,
        required this.scheduledDate,
        required this.notes,
        required this.startedAt,
        required this.completedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.maintenanceRequest,
        required this.quotation,
    });

    // started_at / completed_at are null while a job is still open, so every
    // date is parsed with tryParse instead of parse.
    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] as int? ?? 0,
        maintenanceRequestId: json["maintenance_request_id"] as int?,
        quotationId: json["quotation_id"] as int?,
        technicianId: json["technician_id"] as int?,
        status: json["status"]?.toString() ?? '',
        scheduledDate: DateTime.tryParse(json["scheduled_date"]?.toString() ?? ''),
        notes: json["notes"]?.toString() ?? '',
        startedAt: DateTime.tryParse(json["started_at"]?.toString() ?? ''),
        completedAt: DateTime.tryParse(json["completed_at"]?.toString() ?? ''),
        createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ''),
        maintenanceRequest: json["maintenance_request"] is Map<String, dynamic>
            ? MaintenanceRequest.fromJson(
                json["maintenance_request"] as Map<String, dynamic>)
            : null,
        quotation: json["quotation"] is Map<String, dynamic>
            ? Quotation.fromJson(json["quotation"] as Map<String, dynamic>)
            : null,
    );


}

class Quotation {
    int? id;
    String? price;
    String? notes;
    int? estimatedDays;

    Quotation({this.id, this.price, this.notes, this.estimatedDays});

    factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        id: json["id"] as int?,
        price: json["price"]?.toString(),
        notes: json["notes"]?.toString(),
        estimatedDays: json["estimated_days"] is int
            ? json["estimated_days"] as int
            : int.tryParse(json["estimated_days"]?.toString() ?? ''),
    );
}

class MaintenanceRequest {
    int id;
    int? userId;
    int? vehicleId;
    String description;
    String priority;
    DateTime? preferredDate;
    String status;
    User? user;
    Vehicle? vehicle;

    MaintenanceRequest({
        required this.id,
        required this.userId,
        required this.vehicleId,
        required this.description,
        required this.priority,
        required this.preferredDate,
        required this.status,
        required this.user,
        required this.vehicle,
    });

    factory MaintenanceRequest.fromJson(Map<String, dynamic> json) => MaintenanceRequest(
        id: json["id"] as int? ?? 0,
        userId: json["user_id"] as int?,
        vehicleId: json["vehicle_id"] as int?,
        description: json["description"]?.toString() ?? '',
        priority: json["priority"]?.toString() ?? '',
        preferredDate: DateTime.tryParse(json["preferred_date"]?.toString() ?? ''),
        status: json["status"]?.toString() ?? '',
        user: json["user"] is Map<String, dynamic>
            ? User.fromJson(json["user"] as Map<String, dynamic>)
            : null,
        vehicle: json["vehicle"] is Map<String, dynamic>
            ? Vehicle.fromJson(json["vehicle"] as Map<String, dynamic>)
            : null,
    );

}

class User {
    int id;
    String name;
    String? email;
    String? phone;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] as int? ?? 0,
        name: json["name"]?.toString() ?? '',
        email: json["email"]?.toString(),
        phone: json["phone"]?.toString(),
    );


}

class Vehicle {
    int id;
    String brand;
    String model;
    String year;
    String plateNumber;
    int? currentKm;
    String? image;

    Vehicle({
        required this.id,
        required this.brand,
        required this.model,
        required this.year,
        required this.plateNumber,
        required this.currentKm,
        required this.image,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"] as int? ?? 0,
        brand: json["brand"]?.toString() ?? '',
        model: json["model"]?.toString() ?? '',
        year: json["year"]?.toString() ?? '',
        plateNumber: json["plate_number"]?.toString() ?? '',
        currentKm: json["current_km"] as int?,
        image: json["image"]?.toString(),
    );

}
