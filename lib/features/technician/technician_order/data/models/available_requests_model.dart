
class AvailableRequestsModel {
    bool success;
    List<Data> data;
    Meta meta;

    AvailableRequestsModel({
        required this.success,
        required this.data,
        required this.meta,
    });

    factory AvailableRequestsModel.fromJson(Map<String, dynamic> json) => AvailableRequestsModel(
        success: json["success"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
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

    Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
    };
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

    Map<String, dynamic> toJson() => {
        "id": id,
        "brand": brand,
        "model": model,
        "year": year,
        "plate_number": plateNumber,
    };
}

class Meta {
    int total;
    int perPage;
    int currentPage;

    Meta({
        required this.total,
        required this.perPage,
        required this.currentPage,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "current_page": currentPage,
    };
}
