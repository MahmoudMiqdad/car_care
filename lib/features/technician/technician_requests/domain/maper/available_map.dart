 // تحويل AvailableRequestsModel -> AvailableRequestsEntity
  import 'package:car_care/features/technician/technician_requests/data/models/available_requests_model.dart' as available_model;
import 'package:car_care/features/technician/technician_requests/domain/entities/available_requests_entity.dart';

AvailableRequestsEntity mapAvailable(available_model.AvailableRequestsModel model) {
    return AvailableRequestsEntity(
      success: model.success,
      total: model.meta.total,
      perPage: model.meta.perPage,
      currentPage: model.meta.currentPage,
      data: model.data.map((item) => AvailableRequestDataEntity(
        id: item.id,
        description: item.description,
        priority: item.priority,
        priorityText: item.priorityText,
        status: item.status,
        statusText: item.statusText,
        customer: CustomerEntity(
          id: item.customer.id,
          name: item.customer.name,
          phone: item.customer.phone,
        ),
        vehicle: VehicleEntity(
          id: item.vehicle.id,
          brand: item.vehicle.brand,
          model: item.vehicle.model,
          year: item.vehicle.year,
          plateNumber: item.vehicle.plateNumber,
        ),
        images: item.images.map((img) => ImageEntity(id: img.id, url: img.url)).toList(),
        preferredDate: item.preferredDate,
        createdAt: item.createdAt,
        createdAgo: item.createdAgo,
      )).toList(),
    );
  }
