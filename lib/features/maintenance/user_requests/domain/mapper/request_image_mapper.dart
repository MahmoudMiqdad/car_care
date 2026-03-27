// data/models/request_image_model.dart
import 'package:car_care/features/maintenance/user_requests/data/models/request_image_model.dart';

import '../entities/request_image_entity.dart';

extension RequestImageMapper on RequestImageModel {
  RequestImageEntity toEntity() {
    return RequestImageEntity(
      id: id,
      url: url,
    );
  }
}