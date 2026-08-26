class AvailableRequestsModel {
  bool success;
  List<Data> data;
  Meta meta;

  AvailableRequestsModel({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory AvailableRequestsModel.fromJson(Map<String, dynamic> json) =>
      AvailableRequestsModel(
        success: json["success"] as bool? ?? true,
        data: json["data"] is List
            ? List<Data>.from(
                (json["data"] as List).map(
                  (x) => Data.fromJson(x as Map<String, dynamic>),
                ),
              )
            : <Data>[],
        meta: json["meta"] is Map<String, dynamic>
            ? Meta.fromJson(json["meta"] as Map<String, dynamic>)
            : Meta.empty(),
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
    id: json["id"] as int? ?? 0,
    description: json["description"]?.toString() ?? '',
    priority: json["priority"]?.toString() ?? 'medium',
    priorityText: json["priority_text"]?.toString() ?? '',
    status: json["status"]?.toString() ?? '',
    statusText: json["status_text"]?.toString() ?? '',
    customer: json["customer"] is Map<String, dynamic>
        ? Customer.fromJson(json["customer"] as Map<String, dynamic>)
        : Customer.empty(),
    vehicle: json["vehicle"] is Map<String, dynamic>
        ? Vehicle.fromJson(json["vehicle"] as Map<String, dynamic>)
        : Vehicle.empty(),
    images: json["images"] is List
        ? List<Image>.from(
            (json["images"] as List).map(
              (x) => Image.fromJson(x as Map<String, dynamic>),
            ),
          )
        : <Image>[],
    preferredDate:
        DateTime.tryParse(json["preferred_date"]?.toString() ?? '') ??
        DateTime.now(),
    createdAt:
        DateTime.tryParse(json["created_at"]?.toString() ?? '') ??
        DateTime.now(),
    createdAgo: json["created_ago"]?.toString() ?? '',
  );
}

class Customer {
  int id;
  String name;
  String phone;

  Customer({required this.id, required this.name, required this.phone});

  factory Customer.empty() => Customer(id: 0, name: '', phone: '');

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] as int? ?? 0,
    name: json["name"]?.toString() ?? '',
    phone: json["phone"]?.toString() ?? '',
  );
}

class Image {
  int id;
  String url;

  Image({required this.id, required this.url});

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(id: json["id"] as int? ?? 0, url: json["url"]?.toString() ?? '');

  Map<String, dynamic> toJson() => {"id": id, "url": url};
}

class Vehicle {
  int id;
  String brand;
  String model;
  String year;
  String plateNumber;
  String? image;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.plateNumber,
    this.image,
  });

  factory Vehicle.empty() =>
      Vehicle(id: 0, brand: '', model: '', year: '', plateNumber: '');

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"] as int? ?? 0,
    brand: json["brand"]?.toString() ?? '',
    model: json["model"]?.toString() ?? '',
    year: json["year"]?.toString() ?? '',
    plateNumber: json["plate_number"]?.toString() ?? '',
    image: json["image"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand": brand,
    "model": model,
    "year": year,
    "plate_number": plateNumber,
    "image": image,
  };
}

class Meta {
  int total;
  int perPage;
  int currentPage;

  Meta({required this.total, required this.perPage, required this.currentPage});

  factory Meta.empty() => Meta(total: 0, perPage: 0, currentPage: 1);

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"] as int? ?? 0,
    perPage: json["per_page"] as int? ?? 0,
    currentPage: json["current_page"] as int? ?? 1,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
  };
}
