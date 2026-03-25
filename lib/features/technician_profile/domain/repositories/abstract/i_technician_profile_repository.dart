import 'package:car_care/core/errors/filuar.dart';
import 'package:dartz/dartz.dart';

import '../../entities/technician_profile_entity.dart';

abstract class ITechnicianProfileRepository {

  Future<Either<Failure, TechnicianProfileEntity>> showProfile();
   Future<Either<Failure, TechnicianProfileEntity>> updatetechnicianprofile(Map<String, dynamic> params);
    Future<Either<Failure, TechnicianProfileEntity>> inserttechnicianprofile(Map<String, dynamic> params);

}
