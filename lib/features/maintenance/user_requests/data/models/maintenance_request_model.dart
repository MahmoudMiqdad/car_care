import 'package:car_care/features/maintenance/user_requests/data/models/request_image_model.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/user_model.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/vehicle_model.dart';

class MaintenanceRequestModel {
  bool? success;
   final String? message;
List<MaintenanceRequestdata>? data;

  MaintenanceRequestModel({

    this.success,
     this.message,
    this.data,
  });

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MaintenanceRequestModel();

    return MaintenanceRequestModel(
      success: json["success"],
        message: json['message'],
        data: List<MaintenanceRequestdata>.from(json["data"].map((x) => MaintenanceRequestdata.fromJson(x))),
    );
  }
}

class MaintenanceRequestdata {
  int? id;
  String? description;
  String? priority;
  String? priorityText;
  String? status;
  String? statusText;
  VehicleModel? vehicle;
  UserModel? user;
  List<RequestImageModel>? images;
  List<dynamic>? quotations;
  bool? hasAcceptedQuotation;
  DateTime? preferredDate;
  DateTime? createdAt;
  String? createdAgo;
  DateTime? updatedAt;
  bool? canCancel;
  bool? canEdit;
  bool? canAcceptQuotation;

  MaintenanceRequestdata({
    this.id,
    this.description,
    this.priority,
    this.priorityText,
    this.status,
    this.statusText,
    this.vehicle,
    this.user,
    this.images,
    this.quotations,
    this.hasAcceptedQuotation,
    this.preferredDate,
    this.createdAt,
    this.createdAgo,
    this.updatedAt,
    this.canCancel,
    this.canEdit,
    this.canAcceptQuotation,
  });

  factory MaintenanceRequestdata.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MaintenanceRequestdata();

    return MaintenanceRequestdata(
      id: json["id"],
      description: json["description"],
      priority: json["priority"],
      priorityText: json["priority_text"],
      status: json["status"],
      statusText: json["status_text"],
      vehicle: json["vehicle"] != null
          ? VehicleModel.fromJson(json["vehicle"])
          : null,
      user: json["user"] != null
          ? UserModel.fromJson(json["user"])
          : null,
      images: json["images"] != null
          ? List<RequestImageModel>.from(
              json["images"].map((x) => RequestImageModel.fromJson(x)))
          : [],
      quotations: json["quotations"] != null
          ? List<dynamic>.from(json["quotations"])
          : [],
      hasAcceptedQuotation: json["has_accepted_quotation"],
      preferredDate: json["preferred_date"] != null
          ? DateTime.tryParse(json["preferred_date"])
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      createdAgo: json["created_ago"],
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      canCancel: json["can_cancel"],
      canEdit: json["can_edit"],
      canAcceptQuotation: json["can_accept_quotation"],
    );
  }
}