import 'package:car_care/features/advertisements/data/data_sources/advertisement_remote_data_source.dart';
import 'package:car_care/features/advertisements/data/repositories/advertisement_repository_impl.dart';
import 'package:car_care/features/advertisements/domain/repositories/i_advertisement_repository.dart';
import 'package:car_care/features/advertisements/presentation/cubit/advertisement_cubit.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/locale/locale_cubit.dart';
import 'package:car_care/core/network/api_client.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/data/data_sources/bookings_remote_data_source.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/data/data_sources/customer_bookings_remote_data_source.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/data/repository/customer_bookings_repository_impl.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/domain/repositories/i_bookings_repository.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/repositories/i_customer_bookings_repository.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/data/data_sources/profile_washer_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/data/repositories/profile_washer_repository_impl.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/repositories/i_profile_washer_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/data/data_sources/availability_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/data/repositories/availability_repository_impl.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/domain/repositories/i_availability_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/data/data_sources/ratings_remote_data_source.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/data/repositories/ratings_repository_impl.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/domain/repositories/i_ratings_repository.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/cubit/ratings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/data/data_sources/car_washer_ratings_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/data/repository/car_washer_ratings_repo_impl.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/repositories/i_car_washer_ratings_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/cubit/car_washer_ratings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/data/data_sources/statistics_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/data/repositories/statistics_repository_impl.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/domain/repositories/i_statistics_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/cubit/statistics_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/data/data_sources/car_wash_booking_remote_data_source.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/data/data_sources/washers_remote_data_source.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/data/repositories/car_wash_booking_repository_impl.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/data/repositories/washers_repository_impl.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/repositories/i_car_wash_booking_repository.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/repositories/i_washers_repository.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/cubit/reservation/car_wash_booking_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/cubit/washers/washers_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/data/data_sources/provider_order_remote_data_source.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/data/repositories/i_provider_order_repository_impl.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/repositories/i_provider_order_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_state.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/data/data_sources/provider_profile_remote_data_source.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/data/repositories/i_provider_profile_repository_impl.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/repositories/i_provider_profile_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/data/data_sources/provider_statistics_remote_data_source.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/data/repositories/i_provider_statistics_repository_impl.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/repositories/i_provider_statistics_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/cubit/provider_statistics_cubit.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/data/data_sources/share_location_fuel_remote_data_source.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/data/repositories/share_fuel_provider_location_repository_impl.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/domain/repositories/i_share_location_fuel_repository.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/presentation/cubit/share_location_fuel_cubit.dart';
import 'package:car_care/features/maintenance/user_quotations/data/data_sources/quotations_remote_data_source.dart';
import 'package:car_care/features/maintenance/user_quotations/data/repositories/quotation_repo_impl.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/repositories/i_quotations_repository.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/cubit/quotations_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/data/data_sources/requests_remote_data_source.dart';
import 'package:car_care/features/maintenance/user_requests/data/repositories/requests_repository.dart_impl.dart';
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/accepted_requests_cubit/accepted_requests_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/add_maintenance_request_cubit/add_maintenance_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show/show_requests_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show_request_cubit/show_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/update_request_cubit/update_request_cubit.dart';
import 'package:car_care/features/maintenance/user_statistics/data/data_sources/statistics_remote_data_source.dart';
import 'package:car_care/features/maintenance/user_statistics/data/repositories/statistics_impl.dart';
import 'package:car_care/features/maintenance/user_statistics/domain/repositories/i_statistics.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/cubit/statistics_cubit.dart';
import 'package:car_care/features/sos/data/data_sources/sos_remote_data_source.dart';
import 'package:car_care/features/sos/data/repositories/sos_repository_impl.dart';
import 'package:car_care/features/sos/domain/repositories/i_sos_repository.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/data/data_sources/products_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/products/data/repositories/products_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/repositories/i_products_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/data/repositories/cart_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/add_to_cart/add_to_cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/data/data_sources/checkout_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/repositories/i_checkout_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/cubit/create_order/create_order_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/data/data_sources/customer_orders_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/data/repositories/customer_orders_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/domain/repositories/i_customer_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/order_details/order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/data/data_sources/owner_profile_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/data/repositories/owner_profile_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/domain/repositories/i_owner_profile_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/products/data/data_sources/owner_products_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/owner/products/data/repositories/owner_products_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/owner/products/domain/repositories/i_owner_products_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/data/data_sources/owner_orders_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/data/repositories/owner_orders_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/domain/repositories/i_owner_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_orders/owner_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_order_details/owner_order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/data/data_sources/owner_share_location_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/data/repositories/owner_share_location_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/domain/repositories/i_owner_share_location_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/presentation/cubit/owner_share_location/owner_share_location_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/data/data_sources/spare_order_track_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/data/repositories/spare_order_track_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/repositories/i_spare_order_track_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/cubit/customer_delivery_tracking/customer_delivery_tracking_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/all_products/all_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/product_details/product_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/data/data_sources/shops_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/data/repositories/shops_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/repositories/i_shops_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_details/shop_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_products/shop_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shops_list/shops_list_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_cubit.dart';
import 'package:car_care/features/technician/technician_statistics/data/data_sources/technician_statistics_remote_data_source.dart';
import 'package:car_care/features/technician/technician_statistics/data/repositories/technician_statistics_repository_impl.dart';
import 'package:car_care/features/technician/technician_statistics/domain/repositories/i_technician_statistics_repository.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/cubit/technician_statistics_cubit.dart';
import 'package:car_care/features/technician/technician_jobs/data/data_sources/technician_jobs_remote_data_source.dart';
import 'package:car_care/features/technician/technician_jobs/data/repositories/technician_jobs_repository_impl.dart';
import 'package:car_care/features/technician/technician_jobs/domain/repositories/i_technician_jobs_repository.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_cubit.dart';
import 'package:car_care/features/technician/technician_order/data/data_sources/technician_order_remote_data_source.dart';
import 'package:car_care/features/technician/technician_order/data/repositories/technician_order_repository_impl.dart';
import 'package:car_care/features/technician/technician_order/domain/repositories/i_order_requests_repository.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/available_requests_cubit/available_requests_cubit.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_cubit.dart';
import 'package:car_care/features/technician/technician_profile/data/data_sources/technician_profile_remote_data_source.dart';
import 'package:car_care/features/technician/technician_profile/data/repositories/technician_profile_repo_impl.dart';
import 'package:car_care/features/technician/technician_profile/domain/repositories/i_technician_profile_repository.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_quotations/data/data_sources/technician_quotations_remote_data_source.dart';
import 'package:car_care/features/technician/technician_quotations/data/repositories/technician_quotations_repository_impl.dart';
import 'package:car_care/features/technician/technician_quotations/domain/repositories/i_technician_quotations_repository.dart';
import 'package:car_care/features/technician_sos/data/data_sources/technician_sos_remote_data_source.dart';
import 'package:car_care/features/technician_sos/data/repositories/technician_sos_repository_impl.dart';
import 'package:car_care/features/technician_sos/domain/repositories/i_technician_sos_repository.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/user_fuel/data/data_sources/user_fuel_remote_data_source.dart';
import 'package:car_care/features/user_fuel/data/repositories/user_fuel_repository_impl.dart';
import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_tracking_cubit/user_fuel_tracking_cubit.dart';
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
import 'package:car_care/features/vehicle/presentation/cubit/fuel_logs/fuel_logs_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/maintenance_history/maintenance_history_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/update_vehicle/vehicle_update_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/data/repository/bookings_repo_impl.dart';

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
    ..registerFactory<PasswordResetCubit>(
      () => PasswordResetCubit(getIt<IAuthRepository>()),
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
    ..registerFactory<FuelLogsCubit>(
      () => FuelLogsCubit(getIt<IVehicleRepository>()),
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
    // User statistics
    ..registerLazySingleton<StatisticsRemoteDataSource>(
      () => StatisticsRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<IStatisticsRepository>(
      () => StatisticsRepositoryImpl(getIt()),
    )
    ..registerFactory<StatisticsCubit>(() => StatisticsCubit(getIt()))
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
      () => TechnicianProfileRepositoryImpl(
        getIt<TechnicianProfileRemoteDataSource>(),
      ),
    )
    ..registerFactory<TechnicianProfileCubit>(
      () => TechnicianProfileCubit(getIt<ITechnicianProfileRepository>()),
    )
    ..registerFactory<TechnicianAvailabilityCubit>(
      () => TechnicianAvailabilityCubit(getIt<ITechnicianProfileRepository>()),
    )
    //TechnicianQuotations
    ..registerLazySingleton<TechnicianQuotationsRemoteDataSource>(
      () => TechnicianQuotationsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ITechnicianQuotationsRepository>(
      () => TechnicianQuotationsRepositoryImpl(
        getIt<TechnicianQuotationsRemoteDataSource>(),
      ),
    )
    //Technicianlocation
    ..registerFactory<TechnicianLocationCubit>(
      () => TechnicianLocationCubit(getIt<ITechnicianProfileRepository>()),
    )
    //TechnicianOrder
    ..registerLazySingleton<TechnicianOrderRemoteDataSource>(
      () => TechnicianOrderRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ITechnicianOrderRepository>(
      () => TechnicianOrderRepositoryImpl(
        getIt<TechnicianOrderRemoteDataSource>(),
      ),
    )
    ..registerFactory<AvailableRequestsCubit>(
      () => AvailableRequestsCubit(getIt<ITechnicianOrderRepository>()),
    )
    ..registerFactory<RequestCubit>(
      () => RequestCubit(getIt<ITechnicianOrderRepository>()),
    )
    //TechnicianJobs
    ..registerLazySingleton<TechnicianJobsRemoteDataSource>(
      () => TechnicianJobsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ITechnicianJobsRepository>(
      () =>
          TechnicianJobsRepositoryImpl(getIt<TechnicianJobsRemoteDataSource>()),
    )
    ..registerFactory<TechnicianJobsCubit>(
      () => TechnicianJobsCubit(getIt<ITechnicianJobsRepository>()),
    )
    //
    ..registerLazySingleton<RequestsRemoteDataSource>(
      () => RequestsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IRequestsRepository>(
      () => RequestsRepositoryImpl(getIt<RequestsRemoteDataSource>()),
    )
    ..registerFactory<AcceptedRequestsCubit>(
      () => AcceptedRequestsCubit(getIt<IRequestsRepository>()),
    )
    ..registerFactory<CancelRequestCubit>(
      () => CancelRequestCubit(getIt<IRequestsRepository>()),
    )
    ..registerFactory<AddMaintenanceRequestCubit>(
      () => AddMaintenanceRequestCubit(getIt<IRequestsRepository>()),
    )
    ..registerFactory<UpdateRequestCubit>(
      () => UpdateRequestCubit(getIt<IRequestsRepository>()),
    )
    ..registerFactory<ShowRequestCubit>(
      () => ShowRequestCubit(getIt<IRequestsRepository>()),
    )
    ..registerFactory<RequestsCubit>(
      () => RequestsCubit(getIt<IRequestsRepository>()),
    )
    ..registerLazySingleton<WashersRemoteDataSource>(
      () => WashersRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IWashersRepository>(
      () => WashersRepositoryImpl(getIt<WashersRemoteDataSource>()),
    )
    ..registerFactory<WashersCubit>(
      () => WashersCubit(getIt<IWashersRepository>()),
    )
    ..registerLazySingleton<CarWashBookingRemoteDataSource>(
      () => CarWashBookingRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ICarWashBookingRepository>(
      () =>
          CarWashBookingRepositoryImpl(getIt<CarWashBookingRemoteDataSource>()),
    )
    ..registerFactory<CarWashBookingCubit>(
      () => CarWashBookingCubit(getIt<ICarWashBookingRepository>()),
    )
    ..registerLazySingleton<QuotationsRemoteDataSource>(
      () => QuotationsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IQuotationsRepository>(
      () => QuotationsRepositoryImpl(getIt<QuotationsRemoteDataSource>()),
    )
    ..registerFactory<QuotationsCubit>(
      () => QuotationsCubit(getIt<IQuotationsRepository>()),
    )
    // Bookings
    ..registerLazySingleton<BookingsRemoteDataSource>(
      () => BookingsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IBookingsRepository>(
      () => BookingsRepositoryImpl(getIt<BookingsRemoteDataSource>()),
    )
    ..registerFactory<BookingsCubit>(
      () => BookingsCubit(getIt<IBookingsRepository>()),
    )
    //customer bookings
    ..registerLazySingleton<CustomerBookingsRemoteDataSource>(
      () => CustomerBookingsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ICustomerBookingsRepository>(
      () => CustomerBookingsRepositoryImpl(
        getIt<CustomerBookingsRemoteDataSource>(),
      ),
    )
    ..registerFactory<CustomerBookingsCubit>(
      () => CustomerBookingsCubit(getIt<ICustomerBookingsRepository>()),
    )
    ..registerLazySingleton<ProfileWasherRemoteDataSource>(
      () => ProfileWasherRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IProfileWasherRepository>(
      () => ProfileWasherRepositoryImpl(getIt<ProfileWasherRemoteDataSource>()),
    )
    ..registerFactory<ProfileWasherCubit>(
      () => ProfileWasherCubit(getIt<IProfileWasherRepository>()),
    )
    ..registerLazySingleton<AvailabilityRemoteDataSource>(
      () => AvailabilityRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IAvailabilityRepository>(
      () => AvailabilityRepositoryImpl(getIt<AvailabilityRemoteDataSource>()),
    )
    ..registerFactory<AvailabilityCubit>(
      () => AvailabilityCubit(getIt<IAvailabilityRepository>()),
    )
    ..registerLazySingleton<SosRemoteDataSource>(
      () => SosRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ISosRepository>(
      () => SosRepositoryImpl(getIt<SosRemoteDataSource>()),
    )
    ..registerFactory<SosCubit>(() => SosCubit(getIt<ISosRepository>()))
    //
    ..registerLazySingleton<TechnicianSosRemoteDataSource>(
      () => TechnicianSosRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ITechnicianSosRepository>(
      () => TechnicianSosRepositoryImpl(getIt<TechnicianSosRemoteDataSource>()),
    )
    ..registerFactory<TechnicianSosCubit>(
      () => TechnicianSosCubit(getIt<ITechnicianSosRepository>()),
    )
    ..registerFactory<ShareTechnicianLocationSosCubit>(
      () => ShareTechnicianLocationSosCubit(getIt<ITechnicianSosRepository>()),
    )
    ..registerLazySingleton<CarWasherStatisticsRemoteDataSource>(
      () => CarWasherStatisticsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ICarWasherStatisticsRepository>(
      () => CarWasherStatisticsRepositoryImpl(
        getIt<CarWasherStatisticsRemoteDataSource>(),
      ),
    )
    ..registerFactory<CarWasherStatisticsCubit>(
      () => CarWasherStatisticsCubit(getIt<ICarWasherStatisticsRepository>()),
    )
    ..registerLazySingleton<RatingsRemoteDataSource>(
      () => RatingsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IRatingsRepository>(
      () => RatingsRepositoryImpl(getIt<RatingsRemoteDataSource>()),
    )
    ..registerFactory<RatingsCubit>(
      () => RatingsCubit(getIt<IRatingsRepository>()),
    )
    // CarWasherRatings (washer owner view)
    ..registerLazySingleton<CarWasherRatingsRemoteDataSource>(
      () => CarWasherRatingsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ICarWasherRatingsRepository>(
      () => CarWasherRatingsRepoImpl(getIt<CarWasherRatingsRemoteDataSource>()),
    )
    ..registerFactory<CarWasherRatingsCubit>(
      () => CarWasherRatingsCubit(getIt<ICarWasherRatingsRepository>()),
    )
    //FULE
    ..registerLazySingleton<FuelProviderOrderRemoteDataSource>(
      () => FuelProviderOrderRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IFuelProviderOrderRepository>(
      () => FuelProviderOrderRepositoryImpl(
        getIt<FuelProviderOrderRemoteDataSource>(),
      ),
    )
    ..registerFactory<FuelProviderOrderCubit>(
      () => FuelProviderOrderCubit(getIt<IFuelProviderOrderRepository>()),
    )
    //statisticsFULE
    ..registerLazySingleton<FuelProviderStatisticsRemoteDataSource>(
      () => FuelProviderStatisticsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IFuelProviderStatisticsRepository>(
      () => FuelProviderStatisticsRepositoryImpl(
        getIt<FuelProviderStatisticsRemoteDataSource>(),
      ),
    )
    ..registerFactory<FuelProviderStatisticsCubit>(
      () => FuelProviderStatisticsCubit(
        getIt<IFuelProviderStatisticsRepository>(),
      ),
    )
    //FuelProviderProfile
    ..registerLazySingleton<FuelProviderProfileRemoteDataSource>(
      () => FuelProviderProfileRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IFuelProviderProfileRepository>(
      () => FuelProviderProfileRepositoryImpl(
        getIt<FuelProviderProfileRemoteDataSource>(),
      ),
    )
    ..registerFactory<FuelProviderProfileCubit>(
      () => FuelProviderProfileCubit(getIt<IFuelProviderProfileRepository>()),
    )
    //UserFuel
    ..registerLazySingleton<UserFuelRemoteDataSource>(
      () => UserFuelRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IUserFuelRepository>(
      () => UserFuelRepositoryImpl(getIt<UserFuelRemoteDataSource>()),
    )
    ..registerFactory<UserFuelCubit>(
      () => UserFuelCubit(getIt<IUserFuelRepository>()),
    )
    ..registerFactory<UserFuelTrackingCubit>(
      () => UserFuelTrackingCubit(getIt<IUserFuelRepository>()),
    )
    //ShareFuelProviderLocation
    ..registerLazySingleton<ShareFuelProviderLocationRemoteDataSource>(
      () => ShareFuelProviderLocationRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IShareFuelProviderLocationRepository>(
      () => ShareFuelProviderLocationRepositoryImpl(
        getIt<ShareFuelProviderLocationRemoteDataSource>(),
      ),
    )
    ..registerFactory<ShareFuelProviderLocationCubit>(
      () => ShareFuelProviderLocationCubit(
        getIt<IShareFuelProviderLocationRepository>(),
      ),
    )
    //SpareParts Store - Products
    ..registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IProductsRepository>(
      () => ProductsRepositoryImpl(getIt<ProductsRemoteDataSource>()),
    )
    ..registerFactory<ProductDetailsCubit>(
      () => ProductDetailsCubit(getIt<IProductsRepository>()),
    )
    ..registerFactory<AllProductsCubit>(
      () => AllProductsCubit(getIt<IProductsRepository>()),
    )
    //SpareParts Store - Shops
    ..registerLazySingleton<ShopsRemoteDataSource>(
      () => ShopsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IShopsRepository>(
      () => ShopsRepositoryImpl(getIt<ShopsRemoteDataSource>()),
    )
    ..registerFactory<ShopsListCubit>(
      () => ShopsListCubit(getIt<IShopsRepository>()),
    )
    ..registerFactory<ShopDetailsCubit>(
      () => ShopDetailsCubit(getIt<IShopsRepository>()),
    )
    ..registerFactory<ShopProductsCubit>(
      () => ShopProductsCubit(getIt<IShopsRepository>()),
    )
    //SpareParts Store - Cart
    ..registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ICartRepository>(
      () => CartRepositoryImpl(getIt<CartRemoteDataSource>()),
    )
    ..registerFactory<AddToCartCubit>(
      () => AddToCartCubit(getIt<ICartRepository>()),
    )
    ..registerFactory<CartCubit>(() => CartCubit(getIt<ICartRepository>()))
    //SpareParts Store - Checkout
    ..registerLazySingleton<CheckoutRemoteDataSource>(
      () => CheckoutRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ICheckoutRepository>(
      () => CheckoutRepositoryImpl(getIt<CheckoutRemoteDataSource>()),
    )
    ..registerFactory<CreateOrderCubit>(
      () => CreateOrderCubit(getIt<ICheckoutRepository>()),
    )
    //SpareParts Store - Customer Orders
    ..registerLazySingleton<CustomerOrdersRemoteDataSource>(
      () => CustomerOrdersRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ICustomerOrdersRepository>(
      () =>
          CustomerOrdersRepositoryImpl(getIt<CustomerOrdersRemoteDataSource>()),
    )
    ..registerFactory<OrderDetailsCubit>(
      () => OrderDetailsCubit(getIt<ICustomerOrdersRepository>()),
    )
    ..registerFactory<CustomerOrdersCubit>(
      () => CustomerOrdersCubit(getIt<ICustomerOrdersRepository>()),
    )
    //SpareParts Store - Owner Profile
    ..registerLazySingleton<OwnerProfileRemoteDataSource>(
      () => OwnerProfileRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IOwnerProfileRepository>(
      () => OwnerProfileRepositoryImpl(getIt<OwnerProfileRemoteDataSource>()),
    )
    ..registerFactory<OwnerProfileCubit>(
      () => OwnerProfileCubit(getIt<IOwnerProfileRepository>()),
    )
    //SpareParts Store - Owner Products
    ..registerLazySingleton<OwnerProductsRemoteDataSource>(
      () => OwnerProductsRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IOwnerProductsRepository>(
      () => OwnerProductsRepositoryImpl(getIt<OwnerProductsRemoteDataSource>()),
    )
    ..registerFactory<OwnerProductsCubit>(
      () => OwnerProductsCubit(getIt<IOwnerProductsRepository>()),
    )
    //SpareParts Store - Owner Orders
    ..registerLazySingleton<OwnerOrdersRemoteDataSource>(
      () => OwnerOrdersRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IOwnerOrdersRepository>(
      () => OwnerOrdersRepositoryImpl(getIt<OwnerOrdersRemoteDataSource>()),
    )
    ..registerFactory<OwnerOrdersCubit>(
      () => OwnerOrdersCubit(getIt<IOwnerOrdersRepository>()),
    )
    ..registerFactory<OwnerOrderDetailsCubit>(
      () => OwnerOrderDetailsCubit(getIt<IOwnerOrdersRepository>()),
    )
    //SpareParts Store - Owner Share Location (Delivery)
    ..registerLazySingleton<OwnerShareLocationRemoteDataSource>(
      () => OwnerShareLocationRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IOwnerShareLocationRepository>(
      () => OwnerShareLocationRepositoryImpl(
        getIt<OwnerShareLocationRemoteDataSource>(),
      ),
    )
    ..registerFactory<OwnerShareLocationCubit>(
      () => OwnerShareLocationCubit(getIt<IOwnerShareLocationRepository>()),
    )
    //SpareParts Store - Customer Delivery Tracking
    ..registerLazySingleton<SpareOrderTrackRemoteDataSource>(
      () => SpareOrderTrackRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<ISpareOrderTrackRepository>(
      () => SpareOrderTrackRepositoryImpl(
        getIt<SpareOrderTrackRemoteDataSource>(),
      ),
    )
    ..registerFactory<CustomerDeliveryTrackingCubit>(
      () => CustomerDeliveryTrackingCubit(getIt<ISpareOrderTrackRepository>()),
    )
    //Advertisements
    ..registerLazySingleton<AdvertisementRemoteDataSource>(
      () => AdvertisementRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<IAdvertisementRepository>(
      () => AdvertisementRepositoryImpl(getIt<AdvertisementRemoteDataSource>()),
    )
    ..registerFactory<AdvertisementCubit>(
      () => AdvertisementCubit(getIt<IAdvertisementRepository>()),
    );
}
