class AuthResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;
  final UserModel? user;
  final String? token;
  final String? tokenType;

  AuthResponseModel({
    required this.success,
    required this.message,
    this.errors,
    this.user,
    this.token,
    this.tokenType,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'],
      user: data?['user'] != null
          ? UserModel.fromJson(data['user'])
          : null,
      token: data?['token'],
      tokenType: data?['token_type'],
    );
  }}
class UserModel {
  final int id;
  final String uuid;
  final String name;
  final String email;
  final String? phone;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic tenant;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.tenant,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      tenant: json['tenant'],
      roles: (json['roles'] as List?)
              ?.map((e) => RoleModel.fromJson(e))
              .toList() ??
          [],
    );
  }


}
class RoleModel {
  final int id;
  final String name;
  final String slug;

  RoleModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }


}