import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart';

import 'package:car_care/features/maintenance/user_requests/domain/mapper/request_image_mapper.dart';
import 'package:car_care/features/maintenance/user_requests/domain/mapper/user_mapper.dart';


import 'package:car_care/features/maintenance/user_requests/domain/mapper/vehicle_mapper.dart';


import '../entities/maintenance_request_entity.dart';


extension MaintenanceRequestMapper on MaintenanceRequestModel {
  MaintenanceRequestEntity toEntity() {
    final d = data; 
    return MaintenanceRequestEntity(
      id: d.id,
      description: d.description,
      priority: d.priority,
      priorityText: d.priorityText,
      status: d.status,
      statusText: d.statusText,
      vehicle: d.vehicle.toEntity(),
      user: d.user.toEntity(),
      images: d.images.map((e) => e.toEntity()).toList(),
      hasAcceptedQuotation: d.hasAcceptedQuotation,
      preferredDate: d.preferredDate,
      createdAt: d.createdAt,
      createdAgo: d.createdAgo,
      updatedAt: d.updatedAt,
      canCancel: d.canCancel,
      canEdit: d.canEdit,
      canAcceptQuotation: d.canAcceptQuotation, quotations: [],
    );
  }
}

