import 'package:car_care/features/maintenance/requests/presentation/pages/requests_page.dart';
import 'package:car_care/features/maintenance/statistics/presentation/pages/statistics_page.dart';
import 'package:car_care/features/maintenance/jobs/presentation/pages/jobs_page.dart';
import 'package:car_care/features/maintenance/quotations/presentation/pages/quotations_page.dart';
import 'package:car_care/features/maintenance/availability/presentation/pages/availability_page.dart';
import 'package:car_care/features/profile/presentation/pages/change_passwordpage.dart';
import 'package:car_care/features/technician_profile/presentation/pages/technician_profile_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/vehicle_details_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/add_vehicle_page.dart';
import 'package:car_care/features/vehicle/presentation/pages/my_vehicles_page_page.dart';
import 'package:car_care/features/profile/presentation/pages/profile_page.dart';
import 'package:car_care/features/auth/presentation/pages/login_page.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/features/auth/presentation/pages/register_page.dart';
import 'package:car_care/features/home/presentation/pages/home_page.dart';
import 'package:car_care/features/profile/presentation/pages/profile_setup_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.login,
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
      GoRoute(
        path: Routes.profile_setup,
        name: '/profile_setup',
        builder: (context, state) => const ProfileSetupPage(),
      ),
       GoRoute(
        path: Routes.changepasswordpage,
        name: '/change_password',
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
        path: Routes.technicianprofile,
        name: '/technician_profile',
        builder: (context, state) => const TechnicianProfilePage(),
      ),
            GoRoute(
        path: Routes.availability,
        name: '/availability',
        builder: (context, state) => const AvailabilityPage(),
      ),
            GoRoute(
        path: Routes.quotations,
        name: '/quotations',
        builder: (context, state) => const QuotationsPage(),
      ),
            GoRoute(
        path: Routes.jobs,
        name: '/jobs',
        builder: (context, state) => const JobsPage(),
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
      ],
  );
}
