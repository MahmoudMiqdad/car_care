import 'package:car_care/features/auth/presentation/pages/login_page.dart';

import 'package:car_care/core/routing/routes.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.login,
    debugLogDiagnostics: true,

    routes: [
      // GoRoute(
      //   path: Routes.splash,
      //   name: '/splash',
      //   builder: (context, state) => const SplashPage(),
      // ),
          GoRoute(
        path: Routes.login,
        name: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      //       GoRoute(
      //   path: Routes.signup,
      //   name: '/signup',
      //   builder: (context, state) => const SignupPage(),
      // ),
      //       GoRoute(
      //   path: Routes.forget_password,
      //   name: '/forget_password',
      //   builder: (context, state) => const ForgetPasswordPage(),
      // ),
      //       GoRoute(
      //   path: Routes.otp,
      //   name: '/otp',
      //   builder: (context, state) => const OtpPage(),
      // ),
  //           GoRoute(
  //       path: Routes.register,
  //       name: '/register',
  //       builder: (context, state) => const RegisterPage(),
  //     ),
       ],

  //   // Error handling (Page not found)
  //   errorBuilder: (context, state) => const Scaffold(
  //     body: Center(child: Text('Page not found')),
  //   ),
   );
}
