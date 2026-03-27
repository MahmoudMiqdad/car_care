

class AvailableRequestsEntity {
  final bool success;
  final List<AvailableRequestDataEntity> data;
  final int total;
  final int perPage;
  final int currentPage;

  AvailableRequestsEntity({
    required this.success,
    required this.data,
    required this.total,
    required this.perPage,
    required this.currentPage,
  });
}

class AvailableRequestDataEntity {
  final int id;
  final String description;
  final String priority;
  final String priorityText;
  final String status;
  final String statusText;
  final CustomerEntity customer;
  final VehicleEntity vehicle;
  final List<ImageEntity> images;
  final DateTime preferredDate;
  final DateTime createdAt;
  final String createdAgo;

  AvailableRequestDataEntity({
    required this.id,
    required this.description,
    required this.priority,
    required this.priorityText,
    required this.status,
    required this.statusText,
    required this.customer,
    required this.vehicle,
    required this.images,
    required this.preferredDate,
    required this.createdAt,
    required this.createdAgo,
  });
}

class CustomerEntity {
  final int id;
  final String name;
  final String phone;

  CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
  });
}

class VehicleEntity {
  final int id;
  final String brand;
  final String model;
  final String year;
  final String plateNumber;

  VehicleEntity({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.plateNumber,
  });
}

class ImageEntity {
  final int id;
  final String url;

  ImageEntity({
    required this.id,
    required this.url,
  });
}