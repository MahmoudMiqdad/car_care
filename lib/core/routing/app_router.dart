import 'package:car_care/features/orders/presentation/pages/order_details_page.dart';
import 'package:car_care/features/orders/presentation/pages/orders_page.dart';
import 'package:car_care/features/orders/presentation/pages/price_offer_page.dart';

import 'package:car_care/features/technician/technician_statistics/presentation/pages/technician_statistics_page.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/pages/technician_jobs_page.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/pages/technician_quotations_page.dart';
import 'package:car_care/features/technician/technician_requests/presentation/pages/technician_requests_page.dart';
import 'package:car_care/features/maintenance/user_rate_job/presentation/pages/rate_job_page.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/pages/requests_page.dart';
import 'package:car_care/features/maintenance/user_statistics/presentation/pages/statistics_page.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/pages/quotations_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/maintenance_history_page.dart';
import 'package:car_care/features/user_profile/presentation/pages/change_passwordpage.dart';
import 'package:car_care/features/technician/technician_profile/presentation/pages/technician_profile_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/vehicle_details_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/add_vehicle_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/my_vehicles_page_page.dart';
import 'package:car_care/features/user_profile/presentation/pages/profile_page.dart';
import 'package:car_care/features/auth/presentation/pages/login_page.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/features/auth/presentation/pages/register_page.dart';
import 'package:car_care/features/home/presentation/pages/home_page.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/user_profile/presentation/pages/profile_setup_page.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/UpdateVehiclePage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.technician_requests,
    debugLogDiagnostics: true,
    routes: [
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
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainAppShell(
            bottomNavigationBar: HomeBottomNavBar(
              onItemSelected: (index) {
                if (index == 0) {
                  context.go(Routes.home);
                }
              },
            ),
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
            path: Routes.profile,
            name: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.profile_setup,
        name: '/profile_setup',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ProfileSetupPage(),
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
        path: Routes.updateVehicle,
        name: Routes.updateVehicle,
        builder: (context, state) {
          final vehicleId = state.extra as int;
          return UpdateVehiclePage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: Routes.technicianprofile,
        name: '/technician_profile',
        builder: (context, state) => const TechnicianProfilePage(),
      ),

      GoRoute(
        path: Routes.quotations,
        name: '/quotations',
        builder: (context, state) => const QuotationsPage(),
      ),

      GoRoute(
        path: Routes.statistics,
        name: '/statistics',
        builder: (context, state) => const StatisticsPage(),
      ),
      GoRoute(
        path: Routes.requests,
        name: '/requests',
        builder: (context, state) => const RequestsPage(),
      ),
      GoRoute(
        path: Routes.orders,
        name: '/orders',
        builder: (context, state) => const OrdersPage(),
      ),
      GoRoute(
        path: Routes.order_details,
        name: '/order_details',
        builder: (context, state) {
          final extra = state.extra;
          final id = extra is String ? extra : null;
          return OrderDetailsPage(orderId: id);
        },
      ),
      GoRoute(
        path: Routes.price_offer,
        name: '/price_offer',
        builder: (context, state) => const PriceOfferPage(),
      ),
            GoRoute(
        path: Routes.rate_job,
        name: '/rate_job',
        builder: (context, state) => const RateJobPage(),
      ),
      GoRoute(
        path: Routes.technician_requests,
        name: '/technician_requests',
        builder: (context, state) => const TechnicianRequestsPage(),
      ),
      GoRoute(
        path: Routes.technician_quotations,
        name: '/technician_quotations',
        builder: (context, state) => const TechnicianQuotationsPage(),
      ),
      GoRoute(
        path: Routes.technician_jobs,
        name: '/technician_jobs',
        builder: (context, state) => const TechnicianJobsPage(),
      ),
      GoRoute(
        path: Routes.technician_statistics,
        name: '/technician_statistics',
        builder: (context, state) => const TechnicianStatisticsPage(),
      ),
    ],
  );
}
