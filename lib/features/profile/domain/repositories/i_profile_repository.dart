import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract class IProfileRepository {

  Future<Either<Failure, ProfileEntity>> profile(Map<String, dynamic> params);
  Future<Either<Failure, ProfileEntity>> profileSetup(Map<String, dynamic> params);

}
