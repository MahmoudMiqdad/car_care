class TechnicianProfileEntity {
  final bool? success;
  final TechnicianDataEntity? data;

  TechnicianProfileEntity({
    this.success,
    this.data,
  });
}

class TechnicianDataEntity {
  final int? id;
  final int? userId;
  final String? specialization;
  final int? experienceYears;
  final String? phone;
  final String? city;
  final String? hourlyRate;
  final bool? isAvailable;
  final List<String>? certifications;
  final List<String>? certificationsRaw;
  final UserEntity? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TechnicianDataEntity({
    this.id,
    this.userId,
    this.specialization,
    this.experienceYears,
    this.phone,
    this.city,
    this.hourlyRate,
    this.isAvailable,
    this.certifications,
    this.certificationsRaw,
    this.user,
    this.createdAt,
    this.updatedAt,
  });
}

class UserEntity {
  final int? id;
  final String? name;
  final String? email;

  UserEntity({
    this.id,
    this.name,
    this.email,
  });
}