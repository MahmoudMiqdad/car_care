import '../entities/user_entity.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/user_model.dart';

extension UserMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? 0,
      name: name ?? '',
    );
  }
}