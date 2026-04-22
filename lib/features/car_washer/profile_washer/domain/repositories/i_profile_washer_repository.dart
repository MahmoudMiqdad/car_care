import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import '../entities/profile_washer_entity.dart';

abstract class IProfileWasherRepository {

  Future<Either<Failure, ProfileWasherEntity>> profileWasher(Map<String, dynamic> params);

}
