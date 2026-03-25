class ApiEndpoints {
  ApiEndpoints._();
  // Auth
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
    // Vehicle
      static const String vehicles = '/vehicles';
      //profile
 static const String updateprofile = '/profile';
  static const String updatepassword = '/profile/password';
  static const String updateavatar = '/profile/avatar';
  static const String deletavatar = '/profile/avatar';
  static const String deletprofile = '/profile';
   static const String showprofile = '/auth/me';
   //TechnicianProfile
   static const String technician = '/technician';
     static const String technicianprofile = '$technician/profile';
    static const String inserttechnicianprofile = '$technician/profile';
    static const String updatetechnicianprofile = '$technician/profile';

}