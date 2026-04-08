class UserModel {
  final int? id;
  final String? name;

  UserModel({this.id, this.name});

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserModel();

    return UserModel(
      id: json['id'],
      name: json['name'],
    );
  }
}