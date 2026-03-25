class TechnicianProfile {
  bool? success;
  Data? data;

  TechnicianProfile({this.success, this.data});

  factory TechnicianProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TechnicianProfile();
    return TechnicianProfile(
      success: json["success"] as bool?,
      data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  int? userId;
  String? specialization;
  int? experienceYears;
  String? phone;
  String? city;
  String? hourlyRate;
  bool? isAvailable;
  List<String>? certifications;
  List<String>? certificationsRaw;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
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

  factory Data.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Data();
    return Data(
      id: json["id"] as int?,
      userId: json["user_id"] as int?,
      specialization: json["specialization"] as String?,
      experienceYears: json["experience_years"] as int?,
      phone: json["phone"] as String?,
      city: json["city"] as String?,
      hourlyRate: json["hourly_rate"] as String?,
      isAvailable: json["is_available"] as bool?,
      certifications: json["certifications"] != null
          ? List<String>.from(json["certifications"])
          : null,
      certificationsRaw: json["certifications_raw"] != null
          ? List<String>.from(json["certifications_raw"])
          : null,
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "specialization": specialization,
        "experience_years": experienceYears,
        "phone": phone,
        "city": city,
        "hourly_rate": hourlyRate,
        "is_available": isAvailable,
        "certifications": certifications,
        "certifications_raw": certificationsRaw,
        "user": user?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User();
    return User(
      id: json["id"] as int?,
      name: json["name"] as String?,
      email: json["email"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}