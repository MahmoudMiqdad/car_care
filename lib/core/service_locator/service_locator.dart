import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/locale/locale_cubit.dart';
import 'package:car_care/core/network/api_client.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/domain/repositories/abstract/i_auth_repository.dart';
import 'package:car_care/features/auth/domain/repositories/implementation/auth_repo_impl.dart';
import 'package:car_care/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:car_care/features/profile/domain/repositories/abstract/i_profile_repository.dart';
import 'package:car_care/features/profile/domain/repositories/implementation/profile_repo_impl.dart';
import 'package:car_care/features/profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import 'package:car_care/features/vehicle/domain/repositories/abstract/i_vehicle_repository.dart';
import 'package:car_care/features/vehicle/domain/repositories/implementation/vehicle_repos_impl.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_cubit.dart';
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
      () => AuthRepositoryImpl(
        getIt<AuthRemoteDataSource>(),
        getIt<SecureStorage>(),
      ),
    )
    // Vehicle
    ..registerLazySingleton<VehicleRemoteDataSource>(
      () => VehicleRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IVehicleRepository>(
      () => VehicleRepositoryImpl(getIt<VehicleRemoteDataSource>()),
    )
    ..registerFactory<VehicleCubit>(
      () => VehicleCubit(getIt<IVehicleRepository>()),
    )
    ..registerFactory<VehicleDetailsCubit>(
      () => VehicleDetailsCubit(getIt<IVehicleRepository>()),
    )
    ..registerFactory<VehicleAddCubit>(
      () => VehicleAddCubit(getIt<IVehicleRepository>()),
    )
    
    // Profile
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
    )
    ..registerFactory<ShowProfileCubit>(
      () => ShowProfileCubit(getIt<IProfileRepository>()),
    );
}
