// domain/entities/maintenance_request_entity.dart
import 'package:car_care/features/maintenance/user_requests/domain/entities/request_image_entity.dart';

import 'package:car_care/features/maintenance/user_requests/domain/entities/user_entity.dart';

import 'vehicle_entity.dart';



class MaintenanceRequestEntity {
  final int id;
  final String description;
  final String priority;
  final String priorityText;
  final String status;
  final String statusText;
  final VehicleEntity vehicle;
  final UserEntity user;
  final List<RequestImageEntity> images;
  final List<dynamic> quotations;
  final bool hasAcceptedQuotation;
  final DateTime preferredDate;
  final DateTime createdAt;
  final String createdAgo;
  final DateTime updatedAt;
  final bool canCancel;
  final bool canEdit;
  final bool canAcceptQuotation;

  MaintenanceRequestEntity({
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
}