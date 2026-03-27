
class TechnicianAvailabilityModel {
    bool success;
    String message;

    TechnicianAvailabilityModel({
        required this.success,
        required this.message,
    });

    factory TechnicianAvailabilityModel.fromJson(Map<String, dynamic> json) => TechnicianAvailabilityModel(
        success: json["success"],
        message: json["message"],
    );

}
