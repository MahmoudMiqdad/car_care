import 'package:car_care/features/home/presentation/pages/settings_page.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/list/provider_invoices_cubit.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/show/show_provider_invoice_cubit.dart';
import 'package:car_care/features/provider_invoices/presentation/pages/provider_invoice_details_page.dart';
import 'package:car_care/features/provider_invoices/presentation/pages/provider_invoices_page.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/pages/statistics_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_available_orders_page_wrapper.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/cubit/quotations_cubit.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/pages/quotation_details_page.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show_request_cubit/show_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/pages/maintenance_request_details_page.dart';
import 'package:car_care/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:car_care/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:car_care/features/technician_sos/presentation/pages/all_technician_sos_requests.dart';
import 'package:car_care/features/technician_sos/presentation/technician_sos_request_type.dart';

import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_orders_list_page.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/pages/bookings_page.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/pages/washer_details_page.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/pages/washers_page.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/pages/availability_page.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/pages/washer_bookings_details.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/pages/washer_bookings_page.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/pages/create_profile_washer_page.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/pages/edit_profile_washer_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_order_details_page.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_order_details_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_available_orders_page.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/presentation/pages/share_location_fuel_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/pages/provider_statistics_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/pages/provider_create_profile_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/pages/provider_edit_profile_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/pages/provider_profile_page.dart';
import 'package:car_care/core/widgets/main_shell.dart';
import 'package:car_care/features/sos/presentation/pages/Create_sos_page_wrapper.dart';
import 'package:car_care/features/technician/technician_profile/domain/entities/technician_profile_entity.dart';
import 'package:car_care/features/technician/technician_profile/presentation/pages/insert_technician_profile/insert_technician_profile.dart';
import 'package:car_care/features/technician_sos/presentation/pages/sos_details_page.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_map_page.dart';
import 'package:car_care/features/sos/presentation/pages/all_user_sos_requests.dart';
import 'package:car_care/features/sos/presentation/pages/sos_details_page.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/pages/profile_washer_page.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/pages/washer_reservation_page.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/pages/all_requests_stats_page.dart';
import 'package:car_care/features/technician/technician_order/presentation/pages/order_details_page.dart';
import 'package:car_care/features/technician/technician_order/presentation/pages/orders_page.dart';
import 'package:car_care/features/technician/technician_profile/presentation/pages/tetechnician_profile_view/technician_profile_view_page.dart';
import 'package:car_care/features/technician/technician_profile/presentation/pages/update_technician_profile/update_technician_profile.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_status_gate.dart';
import 'package:car_care/features/technician/technician_statistics/presentation/pages/technician_statistics_page.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/pages/technician_jobs_page.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/pages/technician_quotations_page.dart';

import 'package:car_care/features/maintenance/user_requests/presentation/pages/add_requests_page.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/pages/statistics_page.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/pages/quotations_page.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_sos_create_page_wrapper.dart';
import 'package:car_care/features/user_profile/presentation/pages/profile_page.dart';
import 'package:car_care/features/user_profile/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:car_care/features/vehicle/presentation/pages/maintenance_history_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/vehicle_fuel_logs_page.dart';
import 'package:car_care/features/user_profile/presentation/pages/change_password_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/vehicle_details_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/add_vehicle_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/my_vehicles_page_page.dart';
import 'package:car_care/features/auth/presentation/pages/login_page.dart';
import 'package:car_care/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:car_care/features/auth/presentation/pages/reset_password_page.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/features/more/presentation/pages/more_page.dart';
import 'package:car_care/features/auth/presentation/pages/register_page.dart';
import 'package:car_care/features/home/presentation/pages/home_page.dart';
import 'package:car_care/features/home/presentation/pages/notifications_page.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/home/presentation/widgets/ai_assistant_button.dart';
import 'package:car_care/features/user_profile/presentation/pages/profile_setup_page.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/UpdateVehiclePage.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/pages/cart_page.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/pages/checkout_page.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_my_orders_page.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_order_details_page.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/pages/owner_profile_page.dart';
import 'package:car_care/features/spare_parts_store/owner/specializations/presentation/pages/owner_specializations_page.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/pages/owner_products_page.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/pages/owner_orders_page.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/pages/owner_order_details_page.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/presentation/pages/owner_share_location_page.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/pages/customer_delivery_tracking_page.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/pages/all_products_page.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/pages/customer_product_details_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shop_products_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shops_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/car_washer/car_wash/bookings/presentation/pages/booking_details_page.dart';
import '../../features/car_washer/car_wash/ratings/presentation/pages/ratings_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.signup,
        name: '/signup',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: Routes.forget_password,
        name: '/forget_password',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: '/reset_password',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ResetPasswordPage(
            email: extra?['email'] as String? ?? '',
            resetToken: extra?['resetToken'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: Routes.settings,
        name: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          final location = state.matchedLocation;
          final bottomNavIndex = switch (location) {
            Routes.home => 0,
            Routes.notifications => 1,
            Routes.create_sos => 2,
            Routes.more => 3,
            _ => -1,
          };
          return MainAppShell(
            bottomNavigationBar:
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  bloc: getIt<NotificationsCubit>(),
                  builder: (context, notificationsState) => HomeBottomNavBar(
                    activeIndex: bottomNavIndex,
                    notificationsBadgeCount: notificationsState.unreadCount,
                    onItemSelected: (index) {
                      switch (index) {
                        case 0:
                          context.go(Routes.home);
                          break;
                        case 1:
                          context.go(Routes.notifications);
                          break;
                        case 2:
                          context.go(Routes.create_sos);
                          break;
                        case 3:
                          context.go(Routes.more);
                          break;
                        default:
                          break;
                      }
                    },
                  ),
                ),
            floatingActionButton: const AiAssistantButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: Routes.home,
            name: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: Routes.notifications,
            name: '/notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: Routes.create_sos,
            name: '/Create_sos_page_wrapper',
            builder: (context, state) => const CreateSosPageWrapper(),
          ),
          GoRoute(
            path: Routes.more,
            name: '/more',
            builder: (context, state) => const MorePage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.allUserSosRequests,
        name: '/sos',
        builder: (context, state) => const AllUserSosRequests(),
      ),
      GoRoute(
        path: '/userSosDetailss/:id',
        name: 'sosDetails',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SosDetailsPage(id: id);
        },
      ),
      GoRoute(
        path: Routes.technician_sos_requests,
        name: '/all_technician_sos_requests',
        builder: (context, state) {
          final type = state.extra is SosRequestType
              ? state.extra as SosRequestType
              : SosRequestType.available;
          return TechnicianStatusGate(
            child: AllTechnicianSosRequests(type: type),
          );
        },
      ),
      GoRoute(
        path: '/technicianSosDetails/:id',
        name: 'SosTechnicianDetailsPage',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TechnicianStatusGate(child: SosTechnicianDetailsPage(id: id));
        },
      ),
      GoRoute(
        path: Routes.all_requests,
        name: '/all_requests_stats_page',
        builder: (context, state) => const AllRequestsStatsPage(),
      ),
      GoRoute(
        path: Routes.washers,
        name: '/washers',
        builder: (context, state) => const WashersPage(),
      ),
      GoRoute(
        path: Routes.washerDetails,
        name: 'washerDetails',
        builder: (context, state) {
          final washer = state.extra as WasherEntity;
          return WasherDetailsPage(washer: washer);
        },
      ),

      GoRoute(
        path: Routes.washerReservation,
        name: 'washerReservation',
        builder: (context, state) {
          final extra = state.extra;
          final washer = extra is WasherEntity ? extra : null;
          if (washer == null) return const SizedBox.shrink();
          return WasherReservationPage(washer: washer);
        },
      ),
      GoRoute(
        path: Routes.bookings,
        name: '/bookings',
        builder: (context, state) => const CustomerBookingsPage(),
      ),
      GoRoute(
        path: Routes.washerBookings,
        name: '/washer_bookings',
        builder: (context, state) => const WasherBookingsPage(),
      ),
      GoRoute(
        path: Routes.washerBookingsDetails,
        name: 'washerBookingsDetails',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is BookingsEntity) {
            return WasherBookingsDetails(booking: extra);
          }
          return const SizedBox.shrink();
        },
      ),
      GoRoute(
        path: Routes.bookingDetails,
        builder: (context, state) {
          final booking = state.extra as BookingsEntity;
          return BookingDetailsPage(booking: booking);
        },
      ),
      GoRoute(
        path: Routes.ratings,
        name: 'ratings',
        builder: (context, state) {
          final booking = state.extra as BookingsEntity;
          return RatingsPage(booking: booking);
        },
      ),
      GoRoute(
        path: Routes.availability,
        name: '/availability',
        builder: (context, state) => const AvailabilityPage(),
      ),
      GoRoute(
        path: Routes.profile_washer,
        name: '/profile_washer',
        builder: (context, state) => const ProfileWasherPage(),
      ),
      GoRoute(
        path: Routes.create_profile_washer,
        name: 'createProfileWasher',
        builder: (context, state) => const CreateProfileWasherPage(),
      ),

      GoRoute(
        path: Routes.editProfileWasher,
        name: 'editProfileWasher',
        builder: (context, state) {
          return const EditProfileWasherPage();
        },
      ),

      GoRoute(
        path: Routes.provider_profile,
        name: '/provider_profile',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FuelProviderProfileCubit>(),
          child: const ProviderProfilePage(),
        ),
      ),

      GoRoute(
        path: Routes.provider_edit_profile,
        name: '/provider_edit_profile',
        builder: (context, state) {
          final profile = state.extra as FuelProviderProfileEntity?;
          return BlocProvider(
            create: (_) => getIt<FuelProviderProfileCubit>(),
            child: ProviderEditProfilePage(profile: profile),
          );
        },
      ),

      GoRoute(
        path: Routes.provider_create_profile,
        name: '/provider_create_profile',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FuelProviderProfileCubit>(),
          child: const ProviderCreateProfilePage(),
        ),
      ),
      GoRoute(
        path: Routes.provider_statistics,
        name: '/provider_statistics',
        builder: (context, state) => const ProviderStatisticsPage(),
      ),

      GoRoute(
        path: Routes.share_location_fuel,
        name: '/share_location_fuel',
        builder: (context, state) => const ShareLocationFuelPage(),
      ),
      GoRoute(
        path: Routes.provider_available_orders,
        name: '/provider_available_orders',
        builder: (context, state) => const ProviderAvailableOrdersPage(),
      ),

      GoRoute(
        path: Routes.add_user_fuel,
        builder: (context, state) => const FuelSosCreatePageWrapper(),
      ),

      GoRoute(
        path: Routes.fuelorderslist,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<UserFuelCubit>(),
          child: const FuelOrdersListPage(),
        ),
      ),

      GoRoute(
        path: Routes.fuel_order_details,
        builder: (context, state) {
          final order = state.extra as UserFuelOrderEntity;
          return BlocProvider(
            create: (_) => getIt<UserFuelCubit>(),
            child: FuelOrderDetailsPage(order: order),
          );
        },
      ),
      GoRoute(
        path: Routes.provider_order,
        name: '/provider_available_orders_page_wrapper',
        builder: (context, state) => const ProviderOrdersTabsWrapper(),
      ),
      GoRoute(
        path: '/provider_order_details/:id',
        name: 'providerOrderDetailsPage',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);

          return ProviderOrderDetailsPage(id: id);
        },
      ),
      GoRoute(
        path: Routes.profile_setup,
        name: '/profile_setup',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ProfileSetupPage(),
      ),
      GoRoute(
        path: Routes.user_profile,
        name: '/user_profile_page.dart',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ProfilePage(),
      ),
      GoRoute(
        path: Routes.changepasswordpage,
        name: '/change_password',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: Routes.my_vehicles_page,
        name: '/my_vehicles_page',
        builder: (context, state) => const MyVehiclesPagePage(),
      ),
      GoRoute(
        path: Routes.add_vehicle,
        name: '/add_vehicle',
        builder: (context, state) => const AddVehiclePage(),
      ),
      GoRoute(
        path: Routes.vehicle_details,
        name: '/vehicle_details',
        builder: (context, state) {
          final vehicleId = state.extra as int;
          return VehicleDetailsPage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: Routes.maintenanceHistory,
        name: 'maintenanceHistory',
        builder: (context, state) {
          final vehicleId = state.extra as int? ?? 0;
          return MaintenanceHistoryPage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: Routes.vehicleFuelLogs,
        name: 'vehicleFuelLogs',
        builder: (context, state) {
          final vehicleId = state.extra as int? ?? 0;
          return VehicleFuelLogsPage(vehicleId: vehicleId);
        },
      ),

      GoRoute(
        path: Routes.updateVehicle,
        name: Routes.updateVehicle,
        builder: (context, state) {
          final vehicleId = state.extra as int;
          return UpdateVehiclePage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: Routes.inserttechnicianprofile,
        name: '/insert_technician_profile',
        builder: (context, state) => const InsertTechnicianProfile(),
      ),
      GoRoute(
        path: Routes.updateTechnicianProfile,
        name: '/update_technician_profile',
        builder: (context, state) => TechnicianStatusGate(
          child: TechnicianProfileEditPage(
            initialData: state.extra as TechnicianDataEntity?,
          ),
        ),
      ),
      GoRoute(
        path: Routes.technicianProfileViewBody,
        name: '/technician_profile_view_page',
        builder: (context, state) =>
            const TechnicianStatusGate(child: TechnicianProfileViewPage()),
      ),

      GoRoute(
        path: Routes.maintenance_request_details,
        builder: (context, state) {
          final id = state.extra as int;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<ShowRequestCubit>()),
              BlocProvider(create: (_) => getIt<CancelRequestCubit>()),
            ],
            child: MaintenanceRequestDetailsPage(requestId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.quotations,
        name: '/quotations',
        builder: (context, state) {
          final requestId = state.extra as String;
          return BlocProvider(
            create: (_) => getIt<QuotationsCubit>(),
            child: QuotationsPage(requestId: requestId),
          );
        },
      ),
      GoRoute(
        path: Routes.quotation_details,
        name: '/quotation_details',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          final quotation = data['quotation'] as QuotationEntity;
          final requestId = data['requestId'] as String;

          return BlocProvider(
            create: (_) => getIt<QuotationsCubit>(),
            child: QuotationDetailsPage(
              quotation: quotation,
              requestId: requestId,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.deleteconfirmationdialog,
        name: '/deleteconfirmationdialog',
        builder: (context, state) => const DeleteProfileDialog(),
      ),
      GoRoute(
        path: '${Routes.customerProductDetailsPreview}/:id',
        name: 'customerProductDetailsPreview',
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['id']!);
          return CustomerProductDetailsPage(productId: productId);
        },
      ),
      GoRoute(
        path: Routes.customerAllProducts,
        name: 'customerAllProducts',
        builder: (context, state) => const AllProductsPage(),
      ),
      GoRoute(
        path: Routes.customerShopsList,
        name: 'customerShopsList',
        builder: (context, state) => const ShopsListPage(),
      ),
      GoRoute(
        path: '${Routes.customerShopDetails}/:id',
        name: 'customerShopDetails',
        builder: (context, state) {
          final shopId = int.parse(state.pathParameters['id']!);
          return ShopDetailsPage(shopId: shopId);
        },
      ),
      GoRoute(
        path: '${Routes.customerShopProducts}/:id',
        name: 'customerShopProducts',
        builder: (context, state) {
          final shopId = int.parse(state.pathParameters['id']!);
          final extra = state.extra;
          return ShopProductsPage(
            shopId: shopId,
            initialShop: extra is ShopEntity ? extra : null,
          );
        },
      ),
      GoRoute(
        path: Routes.customerCart,
        name: 'customerCart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: Routes.customerCheckout,
        name: 'customerCheckout',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            final cartCubit = extra['cartCubit'] as CartCubit?;
            final total = (extra['total'] as num?)?.toDouble() ?? 0.0;
            return CheckoutPage(totalPrice: total, cartCubit: cartCubit);
          }
          return CheckoutPage(totalPrice: 0);
        },
      ),
      GoRoute(
        path: '${Routes.customerOrderDetails}/:id',
        name: 'customerOrderDetails',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['id']!);
          return CustomerOrderDetailsPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: Routes.customerOrders,
        name: 'customerOrders',
        builder: (context, state) => const CustomerMyOrdersPage(),
      ),
      GoRoute(
        path: Routes.ownerProfile,
        name: 'ownerProfile',
        builder: (context, state) => const OwnerProfilePage(),
      ),
      GoRoute(
        path: Routes.ownerSpecializations,
        name: 'ownerSpecializations',
        builder: (context, state) => const OwnerSpecializationsPage(),
      ),
      GoRoute(
        path: Routes.ownerProducts,
        name: 'ownerProducts',
        builder: (context, state) => const OwnerProductsPage(),
      ),
      GoRoute(
        path: Routes.ownerOrders,
        name: 'ownerOrders',
        builder: (context, state) => const OwnerOrdersPage(),
      ),
      GoRoute(
        path: '${Routes.ownerOrderDetails}/:id',
        name: 'ownerOrderDetails',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['id']!);
          return OwnerOrderDetailsPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: '${Routes.ownerShareLocation}/:id',
        name: 'ownerShareLocation',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['id']!);
          final extra = state.extra as Map<String, dynamic>?;
          return OwnerShareLocationPage(
            orderId: orderId,
            customerLat: extra?['customerLat'] as double?,
            customerLng: extra?['customerLng'] as double?,
          );
        },
      ),
      GoRoute(
        path: '${Routes.customerTrackDelivery}/:id',
        name: 'customerTrackDelivery',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['id']!);
          final extra = state.extra as Map<String, dynamic>?;
          return CustomerDeliveryTrackingPage(
            orderId: orderId,
            customerLat: extra?['customerLat'] as double?,
            customerLng: extra?['customerLng'] as double?,
          );
        },
      ),

      GoRoute(
        path: Routes.statistics,
        builder: (context, state) => const UserStatisticsPage(),
      ),
      GoRoute(
        path: Routes.addRequest,
        name: '/add_requests_page.dart',

        builder: (context, state) {
          final extra = state.extra;
          final vehicleId = switch (extra) {
            final int id => id.toString(),
            final String id => id,
            _ => '',
          };
          return AddRequestsPage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: Routes.orders,
        name: '/orders_page',
        builder: (context, state) => const TechnicianOrderPage(),
      ),

      GoRoute(
        path: Routes.orderdetails,
        name: '/order_details_page',
        builder: (context, state) {
          final extra = state.extra;
          final id = extra is String ? extra : null;

          return TechnicianStatusGate(
            child: TechnicianOrderDetailsPage(orderId: id ?? ''),
          );
        },
      ),

      GoRoute(
        path: Routes.technician_quotations,
        name: '/technician_quotations',
        builder: (context, state) {
          final extra = state.extra;
          final id = extra is String ? extra : null;

          return TechnicianStatusGate(
            child: TechnicianQuotationsPage(requestId: id ?? ''),
          );
        },
      ),

      GoRoute(
        path: Routes.technician_jobs,
        name: '/technician_jobs',
        builder: (context, state) =>
            const TechnicianStatusGate(child: TechnicianJobsPage()),
      ),
      GoRoute(
        path: Routes.technician_statistics,
        name: '/technician_statistics',
        builder: (context, state) =>
            const TechnicianStatusGate(child: TechnicianStatisticsPage()),
      ),
      GoRoute(
        name: 'TechnicianSosMapPage',
        path: '/technician/sos/:id/map',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TechnicianStatusGate(
            child: TechnicianSosMapPage(
              sosId: int.parse(state.pathParameters['id']!),
              clientLat: extra?['lat'],
              clientLng: extra?['lng'],
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.washer_statistics,
        name: '/washer_statistics',
        builder: (context, state) => const CarWasherStatisticsPage(),
      ),
      GoRoute(
        path: Routes.providerInvoices,
        name: Routes.providerInvoices,
        builder: (context, state) => BlocProvider(
          create: (_) => ProviderInvoicesCubit(getIt()),
          child: const ProviderInvoicesPage(),
        ),
      ),
      GoRoute(
        path: Routes.providerInvoiceDetails,
        name: Routes.providerInvoiceDetails,
        builder: (context, state) => BlocProvider(
          create: (_) => ShowProviderInvoiceCubit(getIt()),
          child: ProviderInvoiceDetailsPage(
            invoiceId: (state.extra as int).toString(),
          ),
        ),
      ),
    ],
  );
}
