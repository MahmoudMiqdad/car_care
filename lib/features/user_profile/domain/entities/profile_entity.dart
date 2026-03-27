class ProfileEntity {
  final bool? success;
  final String? message;
  final int id;
  final String uuid;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String status;
  final int totalVehicles;
  final int totalMaintenanceRequests;
  final int totalSosRequests;
  final DateTime createdAt;
  final String createdAgo;
  final DateTime updatedAt;
  final bool profileCompleted;

  ProfileEntity({
    required this.success,
    required this.message,
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.status,
    required this.totalVehicles,
    required this.totalMaintenanceRequests,
    required this.totalSosRequests,
    required this.createdAt,
    required this.createdAgo,
    required this.updatedAt,
    required this.profileCompleted,
  });
}