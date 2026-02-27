import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/locale/locale_cubit.dart';
import 'package:car_care/core/network/api_client.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/domain/repositories/abstract/i_auth_repository.dart';
import 'package:car_care/features/auth/domain/repositories/implementation/auth_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt
    // Storage
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<SecureStorage>(
      () => SecureStorage(getIt<FlutterSecureStorage>()),
    )
    // Locale
    ..registerLazySingleton<LocaleCubit>(
      () => LocaleCubit(getIt<SecureStorage>()),
    )
    // Networking
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(secureStorage: getIt<SecureStorage>()),
    )
    ..registerLazySingleton<ApiService>(() => ApiService(getIt<ApiClient>()))
    // Auth data source
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
    );
}
