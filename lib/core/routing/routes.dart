// ignore_for_file: constant_identifier_names

class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding_page.dart';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String user_profile = '/user_profile_page.dart';
  static const String profile_setup = '/profile_setup';
  static const String forget_password = '/forget_password';
  static const String changepasswordpage = '/change_password_page';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String more = '/more';
  static const String my_vehicles_page = '/my_vehicles_page';
  static const String add_vehicle = '/add_vehicle';
  static const String vehicle_details = '/vehicle_details';
  static const String updateVehicle = '/update-vehicle';
  static const String deleteconfirmationdialog = '/delete_confirmation_dialog';

  static const String maintenanceHistory = '/maintenanceHistory';
  static const String vehicleFuelLogs = '/vehicle_fuel_logs';
  static const String quotation_details = '/quotation_details';
  static const String inserttechnicianprofile = '/insert_technician_profile';
  static const String availability = '/availability';
  static const String quotations = '/quotations';
  static const String jobs = '/jobs';
  static const String statistics = '/statistics';
  static const String addRequest = '/add_requests_page.dart';
  static const String maintenance_request_details =
      '/maintenance_request_details.dart';
  static const String all_requests = '/all_requests_stats_page';

  static const String rate_job = '/rate_job';
  static const String technician_requests = '/technician_requests';
  static const String technician_quotations = '/technician_quotations';
  static const String technician_jobs = '/technician_jobs';
  static const String technician_statistics = '/technician_statistics';
  static const String technician_rate_job = '/technician_rate_job';
  static const String technicianProfileViewBody =
      '/technician_profile_view_page';
  static const String updateTechnicianProfile = '/update_technician_profile';
  static const String orders = '/orders_page';
  static const String washer_statistics = '/washer_statistics';
  static const String orderdetails = '/order_details_page';
  static const String technicianquotationspage = '/technician_quotations_page';
  static const String washers = '/washers';
  static const String bookings = '/bookings';
  static const String washerBookings = '/washer_bookings';
  static const String washerBookingsDetails = '/washer_bookings_details';
  static const String bookingDetails = '/booking_details';

  static const String ratings = '/ratings';
  static const String show_ratings = '/show_ratings';
  static const String profile_washer = '/profile_washer';
  static const String create_profile_washer = '/create_profile_washer';
  static const String editProfileWasher = '/edit_profile_washer';
  static const String washerDetails = '/washer_details';
  static const String washerReservation = '/washer_reservation';
  static const String allUserSosRequests = '/allUserSosRequests';
  static const String carWasherRatings = '/car_washer_ratings';
  static const String sos = '/sos';
  static const String create_sos = '/Create_sos_page_wrapper';
  static const String sos_details = '/sos_details';
  static const String technician_sos_requests = '/all_technician_sos_requests';
  static const String tracking = '/tracking';
  static const String technician_location = '/technician_location';
  static const String fuel_orders = '/fuel_orders';
  static const String provider_profile = '/provider_profile';
  static const String provider_edit_profile = '/provider_edit_profile';
  static const String provider_create_profile = '/provider_create_profile';
  static const String provider_prices = '/provider_prices';
  static const String provider_statistics = '/provider_statistics';
  static const String available_orders = '/available_orders';
  static const String share_location = '/share_location';
  static const String share_location_fuel = '/share_location_fuel';
  static const String provider_available_orders = '/provider_available_orders';
  static const String userfuel_orders = '/userfuel_orders';
  static const String add_user_fuel = '/fuel_sos_create_page';
  static const String user_fuel_orders = '/user_fuel_orders';
  static const String fuelorderslist = '/fuel_orders_list_page';
  static const String fuel_order_details = '/fuel_order_details';
  static const String provider_order = '/provider_order';
  static const String provider_order_details = '/provider_order_details_page';

  static const String customerProductDetailsPreview =
      '/spare-parts/customer/product-details-preview';
  static String customerProductDetailsPreviewPath(int productId) =>
      '$customerProductDetailsPreview/$productId';

  static const String customerAllProducts =
      '/spare-parts/customer/all-products';

  static const String customerShopsList = '/spare-parts/customer/shops';
  static const String customerShopDetails =
      '/spare-parts/customer/shop-details';
  static String customerShopDetailsPath(int shopId) =>
      '$customerShopDetails/$shopId';
  static const String customerShopProducts =
      '/spare-parts/customer/shop-products';
  static String customerShopProductsPath(int shopId) =>
      '$customerShopProducts/$shopId';

  static const String customerCart = '/spare-parts/customer/cart';

  static const String customerCheckout = '/spare-parts/customer/checkout';
  static const String customerOrderDetails =
      '/spare-parts/customer/order-details';
  static String customerOrderDetailsPath(int orderId) =>
      '$customerOrderDetails/$orderId';

  static const String customerOrders = '/spare-parts/customer/my-orders';

  static const String ownerProfile = '/spare-parts/owner/profile';

  static const String ownerOrders = '/spare-parts/owner/orders';
  static const String ownerOrderDetails = '/spare-parts/owner/order-details';
  static String ownerOrderDetailsPath(int orderId) =>
      '$ownerOrderDetails/$orderId';

  static const String ownerShareLocation = '/spare-parts/owner/share-location';
  static String ownerShareLocationPath(int orderId) =>
      '$ownerShareLocation/$orderId';

  static const String customerTrackDelivery =
      '/spare-parts/customer/track-delivery';
  static String customerTrackDeliveryPath(int orderId) =>
      '$customerTrackDelivery/$orderId';
}
