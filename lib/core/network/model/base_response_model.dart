import 'package:car_care/core/domain/entities/base_response_entity.dart';


class BaseResponseModel {
  final bool success;
  final String message;

  BaseResponseModel({
    required this.success,
    required this.message,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  BaseResponseEntity toEntity() {
    return BaseResponseEntity(
      success: success,
      message: message,
    );
  }
}