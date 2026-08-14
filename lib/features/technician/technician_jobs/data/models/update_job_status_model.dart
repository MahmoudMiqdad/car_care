
class UpdateJobStatusModel {
    bool success;
    String message;
    // Nullable and tolerant: only success/message are actually used
    // (see TechnicianJobsRepositoryImpl._mapUpdate). The backend response
    // shape for `data` also varies by status (e.g. maintenance_record and
    // completed_at are only present once status is "completed"), so this
    // must never throw on a valid 200/success:true response.
    Data? data;

    UpdateJobStatusModel({
        required this.success,
        required this.message,
        this.data,
    });

    factory UpdateJobStatusModel.fromJson(Map<String, dynamic> json) => UpdateJobStatusModel(
        success: json["success"] as bool? ?? true,
        message: json["message"]?.toString() ?? '',
        data: json["data"] is Map<String, dynamic>
            ? Data.fromJson(json["data"] as Map<String, dynamic>)
            : null,
    );

}

class Data {
    int? id;
    int? maintenanceRequestId;
    int? quotationId;
    int? technicianId;
    String? status;
    DateTime? scheduledDate;
    String? notes;
    dynamic startedAt;
    DateTime? completedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    MaintenanceRequest? maintenanceRequest;
    MaintenanceRecord? maintenanceRecord;

    Data({
        this.id,
        this.maintenanceRequestId,
        this.quotationId,
        this.technicianId,
        this.status,
        this.scheduledDate,
        this.notes,
        this.startedAt,
        this.completedAt,
        this.createdAt,
        this.updatedAt,
        this.maintenanceRequest,
        this.maintenanceRecord,
    });

    // Every field parsed leniently: fields such as maintenance_record and
    // completed_at only appear once the job is completed, and the
    // in_progress response legitimately omits them.
    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] as int?,
        maintenanceRequestId: json["maintenance_request_id"] as int?,
        quotationId: json["quotation_id"] as int?,
        technicianId: json["technician_id"] as int?,
        status: json["status"]?.toString(),
        scheduledDate: DateTime.tryParse(json["scheduled_date"]?.toString() ?? ''),
        notes: json["notes"]?.toString(),
        startedAt: json["started_at"],
        completedAt: DateTime.tryParse(json["completed_at"]?.toString() ?? ''),
        createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ''),
        maintenanceRequest: json["maintenance_request"] is Map<String, dynamic>
            ? MaintenanceRequest.fromJson(json["maintenance_request"] as Map<String, dynamic>)
            : null,
        maintenanceRecord: json["maintenance_record"] is Map<String, dynamic>
            ? MaintenanceRecord.fromJson(json["maintenance_record"] as Map<String, dynamic>)
            : null,
    );


}

class MaintenanceRecord {
    int? id;
    int? serviceJobId;
    int? vehicleId;
    int? maintenanceRequestId;
    String? details;
    List<PartsUsed> partsUsed;
    String? completionNotes;
    dynamic recommendations;
    DateTime? completedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    MaintenanceRecord({
        this.id,
        this.serviceJobId,
        this.vehicleId,
        this.maintenanceRequestId,
        this.details,
        this.partsUsed = const [],
        this.completionNotes,
        this.recommendations,
        this.completedAt,
        this.createdAt,
        this.updatedAt,
    });

    factory MaintenanceRecord.fromJson(Map<String, dynamic> json) => MaintenanceRecord(
        id: json["id"] as int?,
        serviceJobId: json["service_job_id"] as int?,
        vehicleId: json["vehicle_id"] as int?,
        maintenanceRequestId: json["maintenance_request_id"] as int?,
        details: json["details"]?.toString(),
        partsUsed: json["parts_used"] is List
            ? (json["parts_used"] as List)
                .whereType<Map<String, dynamic>>()
                .map(PartsUsed.fromJson)
                .toList()
            : const [],
        completionNotes: json["completion_notes"]?.toString(),
        recommendations: json["recommendations"],
        completedAt: DateTime.tryParse(json["completed_at"]?.toString() ?? ''),
        createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ''),
    );


}

class PartsUsed {
    String? name;
    int? quantity;

    PartsUsed({
        this.name,
        this.quantity,
    });

    factory PartsUsed.fromJson(Map<String, dynamic> json) => PartsUsed(
        name: json["name"]?.toString(),
        quantity: json["quantity"] as int?,
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
    };
}

class MaintenanceRequest {
    int? id;
    int? userId;
    int? vehicleId;
    String? description;
    String? priority;
    DateTime? preferredDate;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    MaintenanceRequest({
        this.id,
        this.userId,
        this.vehicleId,
        this.description,
        this.priority,
        this.preferredDate,
        this.status,
        this.createdAt,
        this.updatedAt,
    });
    factory MaintenanceRequest.fromJson(Map<String, dynamic> json) => MaintenanceRequest(
        id: json["id"] as int?,
        userId: json["user_id"] as int?,
        vehicleId: json["vehicle_id"] as int?,
        description: json["description"]?.toString(),
        priority: json["priority"]?.toString(),
        preferredDate: DateTime.tryParse(json["preferred_date"]?.toString() ?? ''),
        status: json["status"]?.toString(),
        createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ''),
    );

}
