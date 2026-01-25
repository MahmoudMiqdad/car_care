import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/locale/locale_cubit.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register FlutterSecureStorage
  getIt
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    // Register SecureStorage
    ..registerLazySingleton<SecureStorage>(
      () => SecureStorage(getIt<FlutterSecureStorage>()),
    )
    // Register LocaleCubit for language management
    ..registerLazySingleton<LocaleCubit>(
      () => LocaleCubit(getIt<SecureStorage>()),
    )
    // Register Dio
    ..registerSingleton<Dio>(Dio())
    // Register ApiService
    ..registerSingleton<ApiService>(
      ApiService(
        getIt.get<Dio>(),
      ),
    );
}
