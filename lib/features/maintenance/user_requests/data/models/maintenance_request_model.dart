

import 'package:car_care/features/maintenance/user_requests/data/models/request_image_model.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/user_model.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/vehicle_model.dart';

class MaintenanceRequestModel {
    bool success;
    Data data;

    MaintenanceRequestModel({
        required this.success,
        required this.data,
    });

    factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) => MaintenanceRequestModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

}

class Data {
    int id;
    String description;
    String priority;
    String priorityText;
    String status;
    String statusText;
    VehicleModel vehicle;
    UserModel user;
   final List<RequestImageModel> images;
    List<dynamic> quotations;
    bool hasAcceptedQuotation;
    DateTime preferredDate;
    DateTime createdAt;
    String createdAgo;
    DateTime updatedAt;
    bool canCancel;
    bool canEdit;
    bool canAcceptQuotation;

    Data({
        required this.id,
        required this.description,
        required this.priority,
        required this.priorityText,
        required this.status,
        required this.statusText,
        required this.vehicle,
        required this.user,
        required this.images,
        required this.quotations,
        required this.hasAcceptedQuotation,
        required this.preferredDate,
        required this.createdAt,
        required this.createdAgo,
        required this.updatedAt,
        required this.canCancel,
        required this.canEdit,
        required this.canAcceptQuotation,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        description: json["description"],
        priority: json["priority"],
        priorityText: json["priority_text"],
        status: json["status"],
        statusText: json["status_text"],
        vehicle: VehicleModel.fromJson(json["vehicle"]),
        user: UserModel.fromJson(json["user"]),
       images: (json['images'] as List) .map((e) => RequestImageModel.fromJson(e)) .toList(),
        quotations: List<dynamic>.from(json["quotations"].map((x) => x)),
        hasAcceptedQuotation: json["has_accepted_quotation"],
        preferredDate: DateTime.parse(json["preferred_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        createdAgo: json["created_ago"],
        updatedAt: DateTime.parse(json["updated_at"]),
        canCancel: json["can_cancel"],
        canEdit: json["can_edit"],
        canAcceptQuotation: json["can_accept_quotation"],
    );


}
