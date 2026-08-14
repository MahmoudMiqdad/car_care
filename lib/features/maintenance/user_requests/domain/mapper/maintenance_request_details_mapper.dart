// maintenance_request_details_mapper.dart

import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_details_model.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_details_entity.dart';

RequestCurrentLocationEntity? _mapLocation(RequestCurrentLocation? loc) =>
    loc == null
        ? null
        : RequestCurrentLocationEntity(
            lat: loc.lat,
            lng: loc.lng,
            updatedAt: loc.updatedAt,
          );

RequestTechnicianProfileEntity _mapTechProfile(
        RequestTechnicianProfile p) =>
    RequestTechnicianProfileEntity(
      specialization: p.specialization,
      experienceYears: p.experienceYears,
      currentLocation: _mapLocation(p.currentLocation),
    );

RequestTechnicianEntity _mapTech(RequestTechnician t) => RequestTechnicianEntity(
      id: t.id,
      name: t.name,
      phone: t.phone,
      technicianProfile: _mapTechProfile(t.technicianProfile),
    );

MaintenanceRequestDetailsEntity mapMaintenanceRequestDetails(
    MaintenanceRequestDetailsModel model) {
  final d = model.data;

  return MaintenanceRequestDetailsEntity(
    success: model.success,
    data: MaintenanceRequestDetailsDataEntity(
      id: d.id,
      description: d.description,
      priority: d.priority,
      priorityText: d.priorityText,
      status: d.status,
      statusText: d.statusText,
      vehicle: d.vehicle == null
          ? null
          : RequestVehicleEntity(
              id: d.vehicle!.id,
              brand: d.vehicle!.brand,
              model: d.vehicle!.model,
              year: d.vehicle!.year,
              plateNumber: d.vehicle!.plateNumber,
              currentKm: d.vehicle!.currentKm,
              image: d.vehicle!.image,
              imagePath: d.vehicle!.imagePath,
            ),
      images: d.images
          .map((e) => RequestImageEntity(id: e.id, url: e.url))
          .toList(),
      quotations: d.quotations
          .map((e) => RequestQuotationEntity(
                id: e.id,
                price: e.price,
                priceFormatted: e.priceFormatted,
                estimatedDays: e.estimatedDays,
                notes: e.notes,
                partsIncluded: e.partsIncluded,
                status: e.status,
                statusText: e.statusText,
                technician: _mapTech(e.technician),
                createdAt: e.createdAt,
                createdAgo: e.createdAgo,
              ))
          .toList(),
      preferredDate: d.preferredDate,
      createdAt: d.createdAt,
      createdAgo: d.createdAgo,
      canCancel: d.canCancel,
      assignedTechnician: d.assignedTechnician == null
          ? null
          : AssignedTechnicianEntity(
              id: d.assignedTechnician!.id,
              name: d.assignedTechnician!.name,
              phone: d.assignedTechnician!.phone,
              specialization: d.assignedTechnician!.specialization,
              experienceYears: d.assignedTechnician!.experienceYears,
              hourlyRate: d.assignedTechnician!.hourlyRate,
              currentLocation: _mapLocation(d.assignedTechnician!.currentLocation),
            ),
    ),
  );
}