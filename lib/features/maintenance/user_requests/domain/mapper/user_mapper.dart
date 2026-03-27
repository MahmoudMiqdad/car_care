// data/models/user_model.dart

import 'package:car_care/features/maintenance/user_requests/data/models/user_model.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/user_entity.dart';


extension UserMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
    );
  }
}