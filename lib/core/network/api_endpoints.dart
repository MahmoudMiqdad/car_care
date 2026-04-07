class ApiEndpoints {
  ApiEndpoints._();
  // Auth
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  // Vehicle
  static const String vehicles = '/vehicles';

  static String vehicleById(int id) => '$vehicles/$id';

  static String vehicleMaintenanceHistory(int id) =>
      '${vehicleById(id)}/maintenance';

  //profile
  static const String updateprofile = '/profile';
  static const String updatepassword = '/profile/password';
  static const String updateavatar = '/profile/avatar';
  static const String deletavatar = '/profile/avatar';
  static const String deletprofile = '/profile';
  static const String showprofile = '/auth/me';
  //Technician
  static const String technician = '/technician';
  static const String technicianprofile = '$technician/profile';
  static const String inserttechnicianprofile = '$technician/profile';
  static const String updatetechnicianprofile = '$technician/profile';
  static const String fetchAvailableRequests = '$technician/available-requests';
  static const String fetchRequest = '$technician/requests';
  static const String technicianavAilability = '$technician/availability';
  static const String submitQuotation = '$technician/requests';
  static const String myJobs = '$technician/my-jobs';
  static const String myacceptedJobs = '$technician/my-jobs/accepted';
  static const String updateJobStatus = '$technician/jobs';
  static const String statisticsTechnician = '$technician/statistics';
  //Maintenance
  static const String maintenance = '/maintenance-requests';
  static const String pendingRequests = '$maintenance/filter/pending';
  static const String acceptedRequests = '$maintenance/filter/accepted';
  static const String completedRequests = '$maintenance/filter/completed';
  //Statistics
  static const String statisticsUser = '$maintenance/statistics';
  //Quotations
  static const String quotations = maintenance;
  //rate-job
  static const String ratejob = '/rate-job';
}
