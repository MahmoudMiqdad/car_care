
class RequestModel {
    bool success;
    Data data;

    RequestModel({
        required this.success,
        required this.data,
    });

    factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

}

class Data {
    int id;
    String description;
    String priority;
    String priorityText;
    String status;
    String statusText;
    Customer customer;
    Vehicle vehicle;
    List<Image> images;
    dynamic myQuotation;
    DateTime preferredDate;
    DateTime createdAt;
    String createdAgo;

    Data({
        required this.id,
        required this.description,
        required this.priority,
        required this.priorityText,
        required this.status,
        required this.statusText,
        required this.customer,
        required this.vehicle,
        required this.images,
        required this.myQuotation,
        required this.preferredDate,
        required this.createdAt,
        required this.createdAgo,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        description: json["description"],
        priority: json["priority"],
        priorityText: json["priority_text"],
        status: json["status"],
        statusText: json["status_text"],
        customer: Customer.fromJson(json["customer"]),
        vehicle: Vehicle.fromJson(json["vehicle"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        myQuotation: json["my_quotation"],
        preferredDate: DateTime.parse(json["preferred_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        createdAgo: json["created_ago"],
    );

}

class Customer {
    int id;
    String name;
    String phone;

    Customer({
        required this.id,
        required this.name,
        required this.phone,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
    };
}

class Image {
    int id;
    String url;

    Image({
        required this.id,
        required this.url,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        url: json["url"],
    );

   
}

class Vehicle {
    int id;
    String brand;
    String model;
    String year;
    String plateNumber;

    Vehicle({
        required this.id,
        required this.brand,
        required this.model,
        required this.year,
        required this.plateNumber,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        brand: json["brand"],
        model: json["model"],
        year: json["year"],
        plateNumber: json["plate_number"],
    );


}
