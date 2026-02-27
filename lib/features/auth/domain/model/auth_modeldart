class AuthResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;
  final UserModel? user;
  final String? token;

  AuthResponseModel({
    required this.success,
    required this.message,
    this.errors,
    this.user,
    this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'],
      user: json['data']?['user'] != null
          ? UserModel.fromJson(json['data']['user'])
          : null,
      token: json['data']?['token'],
    );
  }
}


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
  final List<String> roles;

  UserModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.tenant,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        uuid: json['uuid'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        tenant: json['tenant'],
        roles: List<String>.from(json['roles'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'name': name,
        'email': email,
        'phone': phone,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'tenant': tenant,
        'roles': roles,
      };
}

