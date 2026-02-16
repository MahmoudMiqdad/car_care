import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/failures.dart';
import '../entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, AuthEntity>> login(Map<String, dynamic> params);
  Future<Either<Failure, AuthEntity>> register(Map<String, dynamic> params);
}