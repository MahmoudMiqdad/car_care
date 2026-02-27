import 'package:car_care/core/errors/excptions.dart';

import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/domain/model/auth_modeldart';
import 'package:car_care/features/auth/domain/repositories/abstract/i_auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._authRemoteDataSource);

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<Either<Failure, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    try {
      final result = await _authRemoteDataSource.login({
        'email': email.trim(),
        'password': password.trim(),
      });

      return Right(result);
    } on ServerExpcptions catch (e) {
      return left(e.error);
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> register(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _authRemoteDataSource.register(data);

      return Right(result);
    } on ServerExpcptions catch (e) {
      return left(e.error);
    }
  }
}
