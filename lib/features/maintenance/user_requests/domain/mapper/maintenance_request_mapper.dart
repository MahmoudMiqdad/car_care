import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart'
    as model;

import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';

import 'package:car_care/features/maintenance/user_requests/domain/mapper/quotaion_mapper.dart';
import 'package:car_care/features/maintenance/user_requests/domain/mapper/request_image_mapper.dart';
import 'package:car_care/features/maintenance/user_requests/domain/mapper/vehicle_mapper.dart';

MaintenanceRequestEntity mapMaintenanceRequest(
  model.MaintenanceRequestModel model,
) {
  return MaintenanceRequestEntity(
    success: model.success,
    message: model.message,
    data: model.data.map((item) {
      return DataEntity(
        id: item.id,
        description: item.description,
        priority: item.priority,
        priorityText: item.priorityText,
        status: item.status,
        statusText: item.statusText,

        vehicle: item.vehicle?.toEntity(),

        images: item.images.map((img) => img.toEntity()).toList(),

        quotations: item.quotations.map((q) => q.toEntity()).toList(),

        preferredDate: item.preferredDate,
        createdAt: item.createdAt,
        createdAgo: item.createdAgo,
        canCancel: item.canCancel,
      );
    }).toList(),
  );
}
