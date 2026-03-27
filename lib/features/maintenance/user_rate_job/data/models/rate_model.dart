
class RateModel {
    bool success;
    String message;
    Data data;

    RateModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );


}

class Data {
    int id;
    int rating;
    String review;

    Data({
        required this.id,
        required this.rating,
        required this.review,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        rating: json["rating"],
        review: json["review"],
    );

 
}
