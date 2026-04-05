
class AvatarModel {
    bool success;
    String message;
    Data data;

    AvatarModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory AvatarModel.fromJson(Map<String, dynamic> json) => AvatarModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

  
}

class Data {
    String avatarUrl;

    Data({
        required this.avatarUrl,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        avatarUrl: json["avatar_url"],
    );

 
}
