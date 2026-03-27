
class SubmitQuotationModel {
    bool success;
    String message;
    Data data;

    SubmitQuotationModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SubmitQuotationModel.fromJson(Map<String, dynamic> json) => SubmitQuotationModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

  
}

class Data {
    int id;
    int maintenanceRequestId;
    int price;
    String priceFormatted;
    int estimatedDays;
    bool partsIncluded;
    String notes;
    String status;
    String statusText;
    DateTime createdAt;
    String createdAgo;

    Data({
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

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        maintenanceRequestId: json["maintenance_request_id"],
        price: json["price"],
        priceFormatted: json["price_formatted"],
        estimatedDays: json["estimated_days"],
        partsIncluded: json["parts_included"],
        notes: json["notes"],
        status: json["status"],
        statusText: json["status_text"],
        createdAt: DateTime.parse(json["created_at"]),
        createdAgo: json["created_ago"],
    );


}
