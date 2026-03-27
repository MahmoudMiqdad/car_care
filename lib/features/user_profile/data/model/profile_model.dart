// profile_model.dart
class ProfileModel {
  final bool? success;
  final String? message;
  final Data? data;

  ProfileModel({this.success, this.message, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );
}

class Data {
  final int? id;
  final String? uuid;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? status;
  final Stats? stats;
  final DateTime? createdAt;
  final String? createdAgo;
  final DateTime? updatedAt;
  final bool? profileCompleted;
  final dynamic tenant;
  final List<dynamic>? roles;

  Data({
    this.id,
    this.uuid,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.status,
    this.stats,
    this.createdAt,
    this.createdAgo,
    this.updatedAt,
    this.profileCompleted,
    this.tenant,
    this.roles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
        status: json["status"],
        stats: json["stats"] != null ? Stats.fromJson(json["stats"]) : null,
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        createdAgo: json["created_ago"],
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
        profileCompleted: json["profile_completed"],
        tenant: json["tenant"],
        roles: json["roles"] != null ? List.from(json["roles"]) : null,
      );
}

class Stats {
  final int? totalVehicles;
  final int? totalMaintenanceRequests;
  final int? totalSosRequests;

  Stats({this.totalVehicles, this.totalMaintenanceRequests, this.totalSosRequests});

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        totalVehicles: json["total_vehicles"],
        totalMaintenanceRequests: json["total_maintenance_requests"],
        totalSosRequests: json["total_sos_requests"],
      );

  factory Stats.empty() => Stats(totalVehicles: 0, totalMaintenanceRequests: 0, totalSosRequests: 0);
}
