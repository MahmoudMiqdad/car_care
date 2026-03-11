import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:car_care/features/auth/domain/repositories/abstract/i_auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._secureStorage,
  );

  final AuthRemoteDataSource _authRemoteDataSource;
  final SecureStorage _secureStorage;

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

   
    if (result.token != null && result.token!.isNotEmpty) {
      await _secureStorage.setToken(result.token!);
      return Right(result);
    } else {
      return Left(Failure(message: 'Email أو كلمة المرور غير صحيحة'));
    }
  } on ServerExpcptions catch (e) {
    return Left(e.error);
  }
}

@override
Future<Either<Failure, AuthResponseModel>> register(
  Map<String, dynamic> data,
) async {
  try {
    final result = await _authRemoteDataSource.register(data);

 
    if (result.token != null && result.token!.isNotEmpty) {
      await _secureStorage.setToken(result.token!);
     final token = await _secureStorage.getToken();
print(token);
      return Right(result);
    } else {
    
      return Left(Failure(message: 'حدث خطأ أثناء التسجيل، تحقق من البيانات'));
    }
  } on ServerExpcptions catch (e) {
    return Left(e.error);
  }
}

}
