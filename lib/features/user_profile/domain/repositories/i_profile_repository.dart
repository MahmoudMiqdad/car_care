import 'package:car_care/core/errors/filuar.dart';

import 'package:car_care/features/user_profile/domain/entities/Avatar_entity.dart';
import 'package:dartz/dartz.dart';

import 'package:image_picker/image_picker.dart';
import '../entities/profile_entity.dart';

abstract class IProfileRepository {

  Future<Either<Failure, ProfileEntity>> updateprofile(Map<String, dynamic> params);
  Future<Either<Failure, ProfileEntity>> showprofile( );
  Future<Either<Failure, AvatarEntity>> updateavatar(XFile? avatar);
  Future<Either<Failure, ProfileEntity>> deletavatar();
  Future<Either<Failure, ProfileEntity>> deletprofile( String password);
  Future<Either<Failure, ProfileEntity>> updatepassword(String currentpassword ,String newpassword ,String newpasswordconfirmation ,);
 

}
