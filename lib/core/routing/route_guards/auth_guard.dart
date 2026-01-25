import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGuard {
  static bool _isUserLoggedIn() {
   // return sharedPreferences.getBool('isLoggedIn') ?? false;
    return false;
  }

  static String? redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = _isUserLoggedIn();
    final isGoingToAuthPage = _isAuthRoute(state.uri.toString());

    if (!isLoggedIn && !isGoingToAuthPage) {
      return '/login';
    }

    if (isLoggedIn && isGoingToAuthPage) {
      return '/home';
    }


    return null;
  }

  static bool _isAuthRoute(String location) {
    final authRoutes = ['/splash', '/login', '/signup', '/otp'];
    return authRoutes.contains(location);
  }
}