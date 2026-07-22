import 'package:car_care/core/routing/routes.dart';
import 'package:flutter/foundation.dart';

class RoleRouteResolver {
  const RoleRouteResolver._();

  static String resolve(String? primaryRole) {
    switch (primaryRole) {
      case 'admin':
        if (kDebugMode) {
          debugPrint(
            '[RoleRouteResolver] Admin role detected on mobile — '
            'admin dashboard is web-only. Redirecting to login.',
          );
        }
        return Routes.login;
      case 'shop-owner':
        return Routes.ownerProfile;
      case 'technician':
        return Routes.orders;
      case 'car-washer':
        return Routes.profile_washer;
      case 'fuel-provider':
        return Routes.provider_profile;
      case 'user':
      default:
        return Routes.home;
    }
  }
}
