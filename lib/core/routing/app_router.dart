import 'package:car_care/features/profile/presentation/pages/profile_page.dart';
import 'package:car_care/features/auth/presentation/pages/login_page.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/features/auth/presentation/pages/register_page.dart';
import 'package:car_care/features/home/presentation/pages/home_page.dart';
import 'package:car_care/features/profile/presentation/pages/profile_setup_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.profile_setup,
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
      ],
  );
}

