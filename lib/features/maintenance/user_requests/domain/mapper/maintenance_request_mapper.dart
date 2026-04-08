import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart' as model;
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/user_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/request_image_entity.dart';

MaintenanceRequestEntity mapMaintenanceRequest(model.MaintenanceRequestModel model) {
  return MaintenanceRequestEntity(
    success: model.success,
    message: model.message,
    data: model.data?.map((item) => DataEntity(
      id: item.id,
      description: item.description,
      priority: item.priority,
      priorityText: item.priorityText,
      status: item.status,
      statusText: item.statusText,
      vehicle: item.vehicle != null
          ? VehicleEntity(
              id: item.vehicle!.id ?? 0,
              brand: item.vehicle!.brand ?? '',
              model: item.vehicle!.model ?? '',
              year: item.vehicle!.year ?? '',
              plateNumber: item.vehicle!.plateNumber ?? '',
              currentKm: item.vehicle!.currentKm ?? 0,
              image: item.vehicle!.image,
              imagePath: item.vehicle!.imagePath,
              owner: item.user != null
                  ? UserEntity(
                      id: item.user!.id ?? 0,
                      name: item.user!.name ?? '',
                    )
                  : UserEntity(id: 0, name: ''),
              status: item.vehicle!.status ?? '',
              needsMaintenance: item.vehicle!.needsMaintenance ?? false,
              createdAt: item.vehicle!.createdAt ?? DateTime.now(),
              updatedAt: item.vehicle!.updatedAt ?? DateTime.now(),
            )
          : null,
      user: item.user != null
          ? UserEntity(
              id: item.user!.id ?? 0,
              name: item.user!.name ?? '',
            )
          : null,
      images: item.images?.map((img) => RequestImageEntity(
        id: img.id ?? 0,
        url: img.url ?? '',
      )).toList(),
      quotations: item.quotations,
      hasAcceptedQuotation: item.hasAcceptedQuotation,
      preferredDate: item.preferredDate,
      createdAt: item.createdAt,
      createdAgo: item.createdAgo,
      updatedAt: item.updatedAt,
      canCancel: item.canCancel,
      canEdit: item.canEdit,
      canAcceptQuotation: item.canAcceptQuotation,
    )).toList(),
  );
}