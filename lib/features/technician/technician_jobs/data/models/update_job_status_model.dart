
class UpdateJobStatusModel {
    bool success;
    String message;
    Data data;

    UpdateJobStatusModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory UpdateJobStatusModel.fromJson(Map<String, dynamic> json) => UpdateJobStatusModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

}

class Data {
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
    MaintenanceRecord maintenanceRecord;

    Data({
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
        required this.maintenanceRecord,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        maintenanceRecord: MaintenanceRecord.fromJson(json["maintenance_record"]),
    );


}

class MaintenanceRecord {
    int id;
    int serviceJobId;
    int vehicleId;
    int maintenanceRequestId;
    String details;
    List<PartsUsed> partsUsed;
    String completionNotes;
    dynamic recommendations;
    DateTime completedAt;
    DateTime createdAt;
    DateTime updatedAt;

    MaintenanceRecord({
        required this.id,
        required this.serviceJobId,
        required this.vehicleId,
        required this.maintenanceRequestId,
        required this.details,
        required this.partsUsed,
        required this.completionNotes,
        required this.recommendations,
        required this.completedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory MaintenanceRecord.fromJson(Map<String, dynamic> json) => MaintenanceRecord(
        id: json["id"],
        serviceJobId: json["service_job_id"],
        vehicleId: json["vehicle_id"],
        maintenanceRequestId: json["maintenance_request_id"],
        details: json["details"],
        partsUsed: List<PartsUsed>.from(json["parts_used"].map((x) => PartsUsed.fromJson(x))),
        completionNotes: json["completion_notes"],
        recommendations: json["recommendations"],
        completedAt: DateTime.parse(json["completed_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );


}

class PartsUsed {
    String name;
    int quantity;

    PartsUsed({
        required this.name,
        required this.quantity,
    });

    factory PartsUsed.fromJson(Map<String, dynamic> json) => PartsUsed(
        name: json["name"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
    };
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
    );

}
