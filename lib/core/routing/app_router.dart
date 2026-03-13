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
    initialLocation: Routes.my_vehicles_page,
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
        builder: (context, state) => const VehicleDetailsPage(),
      ),
      ],
  );
}

