import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/locale/locale_cubit.dart';
import 'package:car_care/core/network/api_client.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:car_care/features/technician/technician_statistics/data/data_sources/technician_statistics_remote_data_source.dart';
import 'package:car_care/features/technician/technician_statistics/data/repositories/technician_statistics_repository_impl.dart';
import 'package:car_care/features/technician/technician_statistics/domain/repositories/i_technician_statistics_repository.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/cubit/technician_statistics_cubit.dart';
import 'package:car_care/features/technician/technician_order/data/data_sources/technician_order_remote_data_source.dart';
import 'package:car_care/features/technician/technician_order/data/repositories/technician_order_repository_impl.dart';
import 'package:car_care/features/technician/technician_order/domain/repositories/i_order_requests_repository.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/available_requests_cubit/available_requests_cubit.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_cubit.dart';
import 'package:car_care/features/technician/technician_profile/data/data_sources/technician_profile_remote_data_source.dart';
import 'package:car_care/features/technician/technician_profile/data/repositories/technician_profile_repo_impl.dart';
import 'package:car_care/features/technician/technician_profile/domain/repositories/i_technician_profile_repository.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_quotations/data/data_sources/technician_quotations_remote_data_source.dart';
import 'package:car_care/features/technician/technician_quotations/data/repositories/technician_quotations_repository_impl.dart';
import 'package:car_care/features/technician/technician_quotations/domain/repositories/i_technician_quotations_repository.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_cubit.dart';
import 'package:car_care/features/user_profile/data/data_sources/profile_remote_data_source.dart';
import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/data/repositories/profile_repo_impl.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/change_password_cubit/change_password_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/delete_profile_cubit/delete_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/update_profile_cubit/update_profile_cubit.dart';
import 'package:car_care/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import 'package:car_care/features/vehicle/domain/repositories/i_vehicle_repository.dart';
import 'package:car_care/features/vehicle/data/repositories/vehicle_repos_impl.dart';
import 'package:car_care/features/vehicle/presentation/cubit/delete_vehicle/vehicle_delete_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/maintenance_history/maintenance_history_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/update_vehicle/vehicle_update_cubit.dart';
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
    ..registerFactory<VehicleUpdateCubit>(
      () => VehicleUpdateCubit(getIt<IVehicleRepository>()),
    )
    ..registerFactory<VehicleDeleteCubit>(() => VehicleDeleteCubit(getIt()))
    ..registerFactory(
      () => MaintenanceHistoryCubit(getIt<IVehicleRepository>()),
    )
    // Technician statistics
    ..registerLazySingleton<TechnicianStatisticsRemoteDataSource>(
      () => TechnicianStatisticsRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<ITechnicianStatisticsRepository>(
      () => TechnicianStatisticsRepositoryImpl(getIt()),
    )
    ..registerFactory<TechnicianStatisticsCubit>(
      () => TechnicianStatisticsCubit(getIt()),
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
    )
    ..registerFactory<PasswordCubit>(
      () => PasswordCubit(getIt<IProfileRepository>()),
    )
    ..registerFactory<UpdateProfileCubit>(
      () => UpdateProfileCubit(getIt<IProfileRepository>()),
    )
    ..registerFactory<AvatarCubit>(
      () => AvatarCubit(getIt<IProfileRepository>()),
    )
       ..registerFactory<DeleteProfileCubit>(
      () => DeleteProfileCubit(getIt<IProfileRepository>()),
    )
    //TechnicianProfile
    ..registerLazySingleton<TechnicianProfileRemoteDataSource>(
      () => TechnicianProfileRemoteDataSource(getIt<ApiService>()),
    )
     ..registerLazySingleton<ITechnicianProfileRepository>(
      () => TechnicianProfileRepositoryImpl(getIt<TechnicianProfileRemoteDataSource>()),
    )
      ..registerFactory<TechnicianProfileCubit>(
      () => TechnicianProfileCubit(getIt<ITechnicianProfileRepository>()),
    )
      //TechnicianQuotations
    ..registerLazySingleton<TechnicianQuotationsRemoteDataSource>(
      () => TechnicianQuotationsRemoteDataSource(getIt<ApiService>()),
    )
     ..registerLazySingleton<ITechnicianQuotationsRepository>(
      () => TechnicianQuotationsRepositoryImpl(getIt<TechnicianQuotationsRemoteDataSource>()),
    )
      ..registerFactory<SubmitQuotationCubit>(
      () => SubmitQuotationCubit(getIt<ITechnicianQuotationsRepository>()),
    )
        //TechnicianOrder
    ..registerLazySingleton<TechnicianOrderRemoteDataSource>(
      () => TechnicianOrderRemoteDataSource(getIt<ApiService>()),
    )
     ..registerLazySingleton<ITechnicianOrderRepository>(
      () => TechnicianOrderRepositoryImpl(getIt<TechnicianOrderRemoteDataSource>()),
    )
      ..registerFactory<AvailableRequestsCubit>(
      () => AvailableRequestsCubit(getIt<ITechnicianOrderRepository>()),
    )
        ..registerFactory<RequestCubit>(
      () => RequestCubit(getIt<ITechnicianOrderRepository>()),
    );
}
