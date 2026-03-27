
class MyJobsModel {
    bool success;
    Data data;

    MyJobsModel({
        required this.success,
        required this.data,
    });

    factory MyJobsModel.fromJson(Map<String, dynamic> json) => MyJobsModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );


}

class Data {
    int currentPage;
    List<Datum> data;
    String firstPageUrl;
    int from;
    int lastPage;
    String lastPageUrl;
    List<Link> links;
    dynamic nextPageUrl;
    String path;
    int perPage;
    dynamic prevPageUrl;
    int to;
    int total;

    Data({
        required this.currentPage,
        required this.data,
        required this.firstPageUrl,
        required this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.links,
        required this.nextPageUrl,
        required this.path,
        required this.perPage,
        required this.prevPageUrl,
        required this.to,
        required this.total,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
    );

}

class Datum {
    int id;
    int maintenanceRequestId;
    int quotationId;
    int technicianId;
    String status;
    DateTime scheduledDate;
    String notes;
    dynamic startedAt;
    DateTime completedAt;
    DateTime createdAt;
    DateTime updatedAt;
    MaintenanceRequest maintenanceRequest;

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
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        maintenanceRequestId: json["maintenance_request_id"],
        quotationId: json["quotation_id"],
        technicianId: json["technician_id"],
        status: json["status"],
        scheduledDate: DateTime.parse(json["scheduled_date"]),
        notes: json["notes"],
        startedAt: json["started_at"],
        completedAt: DateTime.parse(json["completed_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        maintenanceRequest: MaintenanceRequest.fromJson(json["maintenance_request"]),
    );


}

class MaintenanceRequest {
    int id;
    int userId;
    int vehicleId;
    String description;
    String priority;
    DateTime preferredDate;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    User user;
    Vehicle vehicle;

    MaintenanceRequest({
        required this.id,
        required this.userId,
        required this.vehicleId,
        required this.description,
        required this.priority,
        required this.preferredDate,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.vehicle,
    });

    factory MaintenanceRequest.fromJson(Map<String, dynamic> json) => MaintenanceRequest(
        id: json["id"],
        userId: json["user_id"],
        vehicleId: json["vehicle_id"],
        description: json["description"],
        priority: json["priority"],
        preferredDate: DateTime.parse(json["preferred_date"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        vehicle: Vehicle.fromJson(json["vehicle"]),
    );

}

class User {
    int id;
    String uuid;
    dynamic tenantId;
    String name;
    String email;
    dynamic emailVerifiedAt;
    String phone;
    dynamic avatar;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    User({
        required this.id,
        required this.uuid,
        required this.tenantId,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.phone,
        required this.avatar,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        uuid: json["uuid"],
        tenantId: json["tenant_id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        phone: json["phone"],
        avatar: json["avatar"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );


}

class Vehicle {
    int id;
    int userId;
    String brand;
    String model;
    String year;
    String plateNumber;
    int currentKm;
    dynamic image;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    Vehicle({
        required this.id,
        required this.userId,
        required this.brand,
        required this.model,
        required this.year,
        required this.plateNumber,
        required this.currentKm,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        userId: json["user_id"],
        brand: json["brand"],
        model: json["model"],
        year: json["year"],
        plateNumber: json["plate_number"],
        currentKm: json["current_km"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "brand": brand,
        "model": model,
        "year": year,
        "plate_number": plateNumber,
        "current_km": currentKm,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}

class Link {
    String? url;
    String label;
    bool active;

    Link({
        required this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );


}
