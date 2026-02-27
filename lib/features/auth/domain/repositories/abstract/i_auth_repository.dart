




import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/auth/domain/model/auth_modeldart';
import 'package:dartz/dartz.dart';

abstract class IAuthRepository {
  Future<Either<Failure,AuthResponseModel>> login(String email,String password);
  Future<Either<Failure,AuthResponseModel>> register(Map<String, dynamic> data);
}

