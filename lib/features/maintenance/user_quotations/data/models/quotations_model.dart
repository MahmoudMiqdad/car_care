
class QuotationsModel {
    bool? success;
    List<Quotations>? data;

    QuotationsModel({
        this.success,
        this.data,
    });

    factory QuotationsModel.fromJson(Map<String, dynamic> json) => QuotationsModel(
        success: json["success"],
        data: List<Quotations>.from(json["data"].map((x) => Quotations.fromJson(x))),
    );

  
}

class Quotations {
    int? id;
    int? price;
    String? priceFormatted;
    int? estimatedDays;
    String? notes;
    bool? partsIncluded;
    String? status;
    String? statusText;
    Technician? technician;
    DateTime? createdAt;
    String? createdAgo;

    Quotations({
        this.id,
        this.price,
        this.priceFormatted,
        this.estimatedDays,
        this.notes,
        this.partsIncluded,
        this.status,
        this.statusText,
        this.technician,
        this.createdAt,
        this.createdAgo,
    });

    factory Quotations.fromJson(Map<String, dynamic> json) => Quotations(
        id: json["id"],
        price: json["price"],
        priceFormatted: json["price_formatted"],
        estimatedDays: json["estimated_days"],
        notes: json["notes"],
        partsIncluded: json["parts_included"],
        status: json["status"],
        statusText: json["status_text"],
        technician: Technician.fromJson(json["technician"]),
        createdAt: DateTime.parse(json["created_at"]),
        createdAgo: json["created_ago"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "price_formatted": priceFormatted,
        "estimated_days": estimatedDays,
        "notes": notes,
        "parts_included": partsIncluded,
        "status": status,
        "status_text": statusText,
       
        "created_at": createdAt,
        "created_ago": createdAgo,
    };
}

class Technician {
    int? id;
    String? name;
    String? phone;
    TechnicianProfile? technicianProfile;

    Technician({
        this.id,
        this.name,
        this.phone,
        this.technicianProfile,
    });

    factory Technician.fromJson(Map<String, dynamic> json) => Technician(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        technicianProfile: TechnicianProfile.fromJson(json["technician_profile"]),
    );


}

class TechnicianProfile {
    String? specialization;
    int? experienceYears;

    TechnicianProfile({
        this.specialization,
        this.experienceYears,
    });

    factory TechnicianProfile.fromJson(Map<String, dynamic> json) => TechnicianProfile(
        specialization: json["specialization"],
        experienceYears: json["experience_years"],
    );

    Map<String, dynamic> toJson() => {
        "specialization": specialization,
        "experience_years": experienceYears,
    };
}
