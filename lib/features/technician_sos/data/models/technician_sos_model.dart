class TechnicianSosModel {
  final bool? success;
  final String? message;
  final TechnicianSosData? data;

  TechnicianSosModel({this.success, this.message, this.data});

  factory TechnicianSosModel.fromJson(Map<String, dynamic> json) {
    return TechnicianSosModel(
      success: json['success'],
      message: json['message']?.toString(),
      data: json['data'] != null ? TechnicianSosData.fromJson(json['data']) : null,);
  }
}
class TechnicianSosData {
  final int? id;
  final double? lat;
  final double? lng;
  final String? description;
  final String? status;
  final String? statusText;
  final String? priority;
  final Vehicle? vehicle;
  final Technician? technician; 
  final bool? canCancel;

  final String? createdAt;
  final String? createdAgo;

  TechnicianSosData({
    this.id,
    this.lat,
    this.lng,
    this.description,
    this.status,
    this.statusText,
    this.priority,
    this.vehicle,
    this.technician,
    this.canCancel,
    this.createdAt,
    this.createdAgo,
  });

  factory TechnicianSosData.fromJson(Map<String, dynamic> json) {
    return TechnicianSosData(
      id: json['id'],
      lat: double.tryParse(json['lat'].toString()),
      lng: double.tryParse(json['lng'].toString()),
      description: json['description'],
      status: json['status'],
      statusText: json['status_text'],
      priority: json['priority'],
      canCancel: json['can_cancel'],

      createdAt: json['created_at'],
      createdAgo: json['created_ago'],

      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : null,

      technician: json['technician'] != null
          ? Technician.fromJson(json['technician'])
          : null,
    );
  }
}

class Vehicle {
  final int? id;
  final String? brand;
  final String? model;
  final String? year;
  final String? plateNumber;
  final int? currentKm;
  final String? image;
  final String? imagePath;
  final Owner? owner;
  final String? status;
  final bool? needsMaintenance;
  final String? createdAt;
  final String? updatedAt;

  Vehicle({
    this.id,
    this.brand,
    this.model,
    this.year,
    this.plateNumber,
    this.currentKm,
    this.image,
    this.imagePath,
    this.owner,
    this.status,
    this.needsMaintenance,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      plateNumber: json['plate_number'],
      currentKm: json['current_km'],
      image: json['image'],
      imagePath: json['image_path'],
      owner: json['owner'] != null
          ? Owner.fromJson(json['owner'])
          : null,
      status: json['status'],
      needsMaintenance: json['needs_maintenance'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
class Technician {
  final int? id;
  final String? name;
  final String? phone;

  Technician({this.id, this.name, this.phone});

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
class Owner {
  final int? id;
  final String? name;

  Owner({this.id, this.name});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
    );
  }
}