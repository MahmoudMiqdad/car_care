class RoleGuard {
  
  static const String admin = 'admin';
  static const String user = 'user';

  static String? checkPermission(String userRole, String requiredRole) {
    if (userRole != requiredRole) {
      return '/home'; 
    }
    return null;
  }
}
