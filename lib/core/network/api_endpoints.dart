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

  static String vehicleFuelLogs(int id) => '${vehicleById(id)}/fuel-logs';

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
  // car-washer (customer)
  static const String customerCarWashers = '/customer/car_washers';
  static String customerCarWasherRatings(int id) =>
      '/customer/car_washers/$id/ratings';
  static const String customerCarwashBookings = '/customer/carwash_bookings';
  static String customerRateBooking(int bookingId) =>
      '/customer/carwash_bookings/$bookingId/rate';
  static String customerCancelBooking(int bookingId) =>
      '/customer/carwash_bookings/$bookingId/cancel';
  // car-washer (washer side)
  static const String washerMyBookings = '/car_washer/my_bookings';
  static String washerAcceptBooking(int id) =>
      '/car_washer/bookings/$id/accept';
  static String washerRejectBooking(int id) =>
      '/car_washer/bookings/$id/reject';
  static String washerUpdateBookingStatus(int id) =>
      '/car_washer/bookings/$id/status';

  // Profile (Car Washer Owner)
  static const String washerMyProfile = '/car_washer/my_profile';
  static const String washerAddOrUpdateProfile = '/car_washer/profile';
  static const String washerProfileLogo = '/car_washer/profile/logo';

  // Statistics
  static const String washerStatistics = '/car_washer/statistics';

  // Availability
  static const String washerAvailability = '/car_washer/availability';
  //sos
  static const String sos = '/sos';

  //technician sos
  static const String technicianSosAvailable = '/technician/sos/available';
  static const String technicianSosRequests = '/technician/sos/requests';
  static const String technicianSosStatistics = '/technician/sos/statistics';
  static const String technicianSosMyRequests = '/technician/sos/my_requests';

  ///fuel_provider
  static const String fuelProvider = '/fuel_provider';
  static const String userFuel = '/customer/fuel_orders';

  // spare-parts-store (customer)
  static const String customerSpareProducts = '/customer/products';
  static String customerSpareProductById(int id) =>
      '$customerSpareProducts/$id';

  // spare-parts-store (customer) - shops
  static const String customerShops = '/customer/shops';
  static String customerShopById(int id) => '$customerShops/$id';
  static String customerShopProducts(int id) => '$customerShops/$id/products';

  // spare-parts-store (customer) - cart
  static const String customerCart = '/customer/cart';
  static String customerCartItemById(int id) => '$customerCart/$id';

  // spare-parts-store (customer) - orders / checkout
  static const String customerOrders = '/customer/orders';
  static String customerOrderById(int id) => '$customerOrders/$id';
  static String customerCancelOrder(int id) => '$customerOrders/$id/cancel';

  // spare-parts-store (owner)
  static const String ownerShopProfile = '/shop/profile';
  static const String ownerOrders = '/shop/orders';
  static String ownerOrderById(int id) => '$ownerOrders/$id';
  static String ownerAcceptOrder(int id) => '$ownerOrders/$id/accept';
  static String ownerRejectOrder(int id) => '$ownerOrders/$id/reject';
  static String ownerUpdateOrderStatus(int id) => '$ownerOrders/$id/status';
  static String ownerShareLocation(int id) => '$ownerOrders/$id/location';

  // spare-parts-store (customer) - delivery tracking
  static String customerTrackSpareOrder(int id) => '$customerOrders/$id/track';

  // Advertisements (public, unauthenticated)
  static const String activeAdvertisements = '/advertisements/active';
}
