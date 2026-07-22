import 'package:car_care/core/routing/routes.dart';
import 'package:flutter/foundation.dart';

class RoleRouteResolver {
  const RoleRouteResolver._();

  static const _rolePriority = [
    'admin',
    'shop-owner',
    'technician',
    'car-washer',
    'fuel-provider',
    'user',
  ];

  /// Picks the highest-priority role from a list — used after token validation.
  static String pickPrimaryRole(List<String> roles) {
    for (final priority in _rolePriority) {
      if (roles.contains(priority)) return priority;
    }
    return roles.isNotEmpty ? roles.first : 'user';
  }

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
