import 'package:car_care/core/routing/routes.dart';
import 'package:flutter/foundation.dart';

/// Maps a stored primaryRole string to the correct initial route for that role.
/// Admin is intentionally excluded from mobile — it belongs to the web dashboard.
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
