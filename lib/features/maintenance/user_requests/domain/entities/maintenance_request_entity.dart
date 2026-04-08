import 'package:car_care/features/maintenance/user_requests/domain/entities/request_image_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/user_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/vehicle_entity.dart';

class MaintenanceRequestEntity {
  final bool? success;
  final String? message;
  final List<DataEntity>? data;

  MaintenanceRequestEntity({
    this.success,
    this.message,
    this.data,
  });
}

class DataEntity {
  final int? id;
  final String? description;
  final String? priority;
  final String? priorityText;
  final String? status;
  final String? statusText;
  final VehicleEntity? vehicle;
  final UserEntity? user;
  final List<RequestImageEntity>? images;
  final List<dynamic>? quotations;
  final bool? hasAcceptedQuotation;
  final DateTime? preferredDate;
  final DateTime? createdAt;
  final String? createdAgo;
  final DateTime? updatedAt;
  final bool? canCancel;
  final bool? canEdit;
  final bool? canAcceptQuotation;

  DataEntity({
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
}