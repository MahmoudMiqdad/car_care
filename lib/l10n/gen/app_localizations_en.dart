// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get appTitle => 'CarCare Services';

  @override
  String get maintenanceRequestsTitle => 'Maintenance Requests';

  @override
  String get totalRequestsLabel => 'Total Requests';

  @override
  String get uploadLogoLabel => 'Upload Logo';

  @override
  String vehicleOwnerWithParamLabel(String name) {
    return 'Owner: $name';
  }

  @override
  String get roleTechnician => 'Technician';

  @override
  String get roleCarWasher => 'Car Wash';

  @override
  String get roleFuelProvider => 'Fuel Provider';

  @override
  String get roleShopOwner => 'Shop Owner';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get myServicesAsProvider => 'My Services as Provider';

  @override
  String get joinAsServiceProvider => 'Join as Service Provider';

  @override
  String get applyAsTechnician => 'Apply as Technician';

  @override
  String get registerCarWash => 'Register Car Wash';

  @override
  String get registerAsFuelProvider => 'Register as Fuel Provider';

  @override
  String get openSparePartsShop => 'Open Spare Parts Shop';

  @override
  String get maintenanceRequests => 'Maintenance Requests';

  @override
  String get technicianProfile => 'Technician Profile';

  @override
  String get myJobs => 'My Jobs';

  @override
  String get availableSosRequests => 'Available SOS Requests';

  @override
  String get acceptedSosRequests => 'Accepted SOS Requests';

  @override
  String get myStatistics => 'My Statistics';

  @override
  String get myInvoices => 'My Invoices';

  @override
  String get carWashProfile => 'Car Wash Profile';

  @override
  String get bookings => 'Bookings';

  @override
  String get statistics => 'Statistics';

  @override
  String get fuelProviderProfile => 'Fuel Provider Profile';

  @override
  String get fuelOrders => 'Fuel Orders';

  @override
  String get fuelProvider => 'Fuel Provider';

  @override
  String get shareLocation => 'Share Location';

  @override
  String get shopProfile => 'Shop Profile';

  @override
  String get shopOrders => 'Shop Orders';

  @override
  String get shopProducts => 'Shop Products';

  @override
  String get shopSpecializations => 'Shop Specializations';

  @override
  String get optionsTitle => 'Options';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitleMaintenance => 'Smart Car Maintenance';

  @override
  String get onboardingSubtitleMaintenance => 'Track your vehicle\'s service history, get timely reminders, and request maintenance with just a tap.';

  @override
  String get onboardingTitleEmergency => 'Emergency Roadside Help';

  @override
  String get onboardingSubtitleEmergency => 'Stuck on the road? Send an SOS and get a certified technician to your location in minutes.';

  @override
  String get onboardingTitleAllInOne => 'All-in-One Car Services';

  @override
  String get onboardingSubtitleAllInOne => 'Fuel delivery, car wash, marketplace and more — everything your car needs, in one app.';

  @override
  String get washerSelectProvinceMessage => 'Please select a province';

  @override
  String get enableLocationPrompt => 'Please enable location services';

  @override
  String get locationErrorPrefix => 'Location error';

  @override
  String get requestSentSuccess => 'Request sent successfully ✓';

  @override
  String get cancelSosQuestion => 'What is the reason for cancelling the request?';

  @override
  String get cancelSosHint => 'Enter the reason for cancelling the emergency request here...';

  @override
  String get trackTechnician => 'Track Technician';

  @override
  String get searchingForTechnicianTitle => 'Searching for Technician';

  @override
  String get searchingForTechnicianSubtitle => 'Finding the nearest available technician for you, please wait a moment';

  @override
  String createdAgoLabel(String time) {
    return 'Created $time';
  }

  @override
  String get technicianOnWayLiveTracking => 'Technician is on the way - live tracking';

  @override
  String get waitingForLocationUpdate => 'Waiting for location update...';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get cartPageTitle => 'Shopping Cart';

  @override
  String get checkoutButton => 'Checkout';

  @override
  String get confirmOrderTitle => 'Confirm Order';

  @override
  String get orderCreatedSuccessfully => 'Order created successfully';

  @override
  String get orderTotalLabel => 'Order Total';

  @override
  String get currencySyp => 'SYP';

  @override
  String get pleaseSelectDeliveryLocation => 'Please select the delivery location on the map';

  @override
  String get pleaseEnterAddressNote => 'Please enter an address note';

  @override
  String get confirmOrderButton => 'Confirm Order';

  @override
  String get addressNoteLabel => 'Address Note';

  @override
  String get addressNoteHint => 'e.g., street name, building number, apartment, or nearby landmark';

  @override
  String get deliveryLocationLabel => 'Delivery Location';

  @override
  String get selectLocationFromMapHint => 'Select location from map';

  @override
  String get locationSelectedBadge => 'Selected';

  @override
  String get changeLocationButton => 'Change Location';

  @override
  String get appName => 'CarCare';

  @override
  String get noAvailableRequests => 'No requests available at the moment';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get assistantChatTitle => 'Smart Assistant';

  @override
  String get assistantChatHint => 'Type your message here...';

  @override
  String get assistantChatEmpty => 'No messages yet, start the conversation';

  @override
  String get assistantChatTyping => 'Assistant is typing...';

  @override
  String get assistantChatDeleteHistoryTitle => 'Delete Chat History';

  @override
  String get assistantChatDeleteHistoryConfirm => 'Are you sure you want to delete all chat history?';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create New Account';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get enterOtp => 'Enter Verification Code';

  @override
  String get otpSent => 'Verification code sent to';

  @override
  String get resendOtp => 'Resend Code';

  @override
  String get resendOtpIn => 'Resend in';

  @override
  String get verify => 'Verify';

  @override
  String get home => 'Home';

  @override
  String get schedules => 'Service Appointments';

  @override
  String get complaints => 'Car Issues';

  @override
  String get profile => 'Profile';

  @override
  String get mySchedules => 'My Appointments';

  @override
  String get upcomingSchedules => 'Upcoming Appointments';

  @override
  String get nextPumpingSchedule => 'Next Service Appointment';

  @override
  String get scheduleDetails => 'Appointment Details';

  @override
  String get viewAllSchedules => 'View All Appointments';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get actualStartTime => 'Actual Start Time';

  @override
  String get actualEndTime => 'Actual End Time';

  @override
  String get status => 'Status';

  @override
  String get notes => 'Notes';

  @override
  String get createdBy => 'Created By';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get active => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get startsIn => 'Starts in';

  @override
  String get activeNow => 'Active Now';

  @override
  String get endedAgo => 'Ended';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get dateRange => 'Date Range';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get myComplaints => 'My Car Issues';

  @override
  String get submitComplaint => 'Report Issue';

  @override
  String get complaintDetails => 'Issue Details';

  @override
  String get complaintTitle => 'Issue Title';

  @override
  String get complaintDescription => 'Issue Description';

  @override
  String get complaintCategory => 'Issue Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get noWater => 'Engine Issue';

  @override
  String get waterQuality => 'Tire Issue';

  @override
  String get lowPressure => 'Battery Issue';

  @override
  String get scheduleIssue => 'Service Delay';

  @override
  String get other => 'Other';

  @override
  String get pending => 'Pending';

  @override
  String get inProgress => 'In Progress';

  @override
  String get resolved => 'Resolved';

  @override
  String get rejected => 'Rejected';

  @override
  String get adminResponse => 'Service Response';

  @override
  String get handledBy => 'Handled By';

  @override
  String get handledAt => 'Handled At';

  @override
  String get createdAt => 'Created At';

  @override
  String get updatedAt => 'Updated At';

  @override
  String get complaintSubmitted => 'Issue Reported Successfully';

  @override
  String get region => 'Service Center';

  @override
  String get unit => 'Unit';

  @override
  String get neighborhood => 'Neighborhood';

  @override
  String get zone => 'Zone';

  @override
  String get selectRegion => 'Select Service Center';

  @override
  String get selectUnit => 'Select Unit';

  @override
  String get selectNeighborhood => 'Select Neighborhood';

  @override
  String get selectZone => 'Select Zone';

  @override
  String get location => 'Location';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get clearSelection => 'Clear Selection';

  @override
  String get myProfile => 'My Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileUpdated => 'Profile Updated Successfully';

  @override
  String get role => 'Role';

  @override
  String get admin => 'Admin';

  @override
  String get operator => 'Operator';

  @override
  String get citizen => 'Customer';

  @override
  String get defaultLocation => 'Default Location';

  @override
  String get watchedLocation => 'Watched Location';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get errorOccurred => 'An Error Occurred';

  @override
  String get networkError => 'Network Connection Error';

  @override
  String get serverError => 'Server Error';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noData => 'No Data';

  @override
  String get noDataSubtitle => 'Check back later or add a new request';

  @override
  String get noSchedules => 'No Appointments';

  @override
  String get noComplaints => 'No Reported Issues';

  @override
  String get noSchedulesMessage => 'No service appointments at the moment';

  @override
  String get noComplaintsMessage => 'You haven\'t reported any issues yet';

  @override
  String get pullToRefresh => 'Pull to Refresh';

  @override
  String get releaseToRefresh => 'Release to Refresh';

  @override
  String get loadMore => 'Load More';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get viewSchedules => 'View Appointments';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get passwordTooShort => 'Password too short (minimum 6 characters)';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String maxCharacters(int max) {
    return 'Maximum $max characters';
  }

  @override
  String charactersRemaining(int count) {
    return '$count characters remaining';
  }

  @override
  String get loginSuccess => 'Login Successful';

  @override
  String get registrationSuccess => 'Registration Successful';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get confirm => 'Confirm';

  @override
  String get language => 'Language';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get appNameAr => 'CarCareX';

  @override
  String get splashScreen => 'Splash Screen';

  @override
  String get profileSetup => 'Profile Setup';

  @override
  String get myVehicles => 'My Vehicles';

  @override
  String get addVehicle => 'Add Vehicle';

  @override
  String get editVehicle => 'Edit Vehicle';

  @override
  String get vehicleDetails => 'Vehicle Details';

  @override
  String get maintenanceHistory => 'Maintenance History';

  @override
  String get vinNumber => 'VIN Number';

  @override
  String get plateNumber => 'Plate Number';

  @override
  String get brand => 'Brand';

  @override
  String get model => 'Model';

  @override
  String get year => 'Year';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get maintenanceRequest => 'Maintenance Request';

  @override
  String get serviceType => 'Service Type';

  @override
  String get oilChange => 'Oil Change';

  @override
  String get inspection => 'Inspection';

  @override
  String get repair => 'Repair';

  @override
  String get technicianOffers => 'Technician Offers';

  @override
  String get requestStatus => 'Request Status';

  @override
  String get rateService => 'Rate Service';

  @override
  String get emergencySOS => 'Emergency SOS';

  @override
  String get sosButton => 'SOS Button';

  @override
  String get emergencyStatus => 'Emergency Status';

  @override
  String get carWash => 'Car Wash';

  @override
  String get bookCarWash => 'Book Car Wash';

  @override
  String get washBookingStatus => 'Booking Status';

  @override
  String get centerWash => 'Center Wash';

  @override
  String get mobileWash => 'Mobile Wash';

  @override
  String get basicWash => 'Basic Wash';

  @override
  String get premiumWash => 'Premium Wash';

  @override
  String get fullWash => 'Full Wash';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get products => 'Products';

  @override
  String get productDetails => 'Product Details';

  @override
  String get cart => 'Cart';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get checkout => 'Checkout';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get rentX => 'Rent Cars';

  @override
  String get availableCars => 'Available Cars';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get rentalPeriod => 'Rental Period';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get bookNow => 'Book Now';

  @override
  String get sellX => 'Sell Cars';

  @override
  String get sellListings => 'Sell Listings';

  @override
  String get myListings => 'My Listings';

  @override
  String get publishListing => 'Publish Listing';

  @override
  String get contactSeller => 'Contact Seller';

  @override
  String get fuelX => 'Fuel Delivery';

  @override
  String get fuelRequest => 'Fuel Request';

  @override
  String get fuelType => 'Fuel Type';

  @override
  String get gasoline91 => 'Gasoline 91';

  @override
  String get gasoline95 => 'Gasoline 95';

  @override
  String get diesel => 'Diesel';

  @override
  String get quantity => 'Quantity';

  @override
  String get liters => 'Liters';

  @override
  String get fuelOrderStatus => 'Fuel Order Status';

  @override
  String get carOwner => 'Car Owner';

  @override
  String get technician => 'Technician';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get proceed => 'Proceed';

  @override
  String get continueButton => 'Continue';

  @override
  String get select => 'Select';

  @override
  String get choose => 'Choose';

  @override
  String get onTheWay => 'On The Way';

  @override
  String get arrived => 'Arrived';

  @override
  String get delivered => 'Delivered';

  @override
  String get assigned => 'Assigned';

  @override
  String get requested => 'Requested';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get noVehicles => 'No Vehicles';

  @override
  String get noOffers => 'No Offers';

  @override
  String get noListings => 'No Listings';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get useCurrentLocation => 'Use My Current Location';

  @override
  String get enterAddress => 'Enter Address';

  @override
  String get city => 'City';

  @override
  String get pickImage => 'Pick Image';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get notifications => 'Notifications';

  @override
  String get more => 'More';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get searchCars => 'Search cars...';

  @override
  String get sortBy => 'Sort By';

  @override
  String get priceLowHigh => 'Price: Low to High';

  @override
  String get priceHighLow => 'Price: High to Low';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get timeSlot => 'Time Slot';

  @override
  String get now => 'Now';

  @override
  String get schedule => 'Schedule';

  @override
  String get price => 'Price';

  @override
  String get cost => 'Cost';

  @override
  String get estimatedPrice => 'Estimated Price';

  @override
  String get rating => 'Rating';

  @override
  String get stars => 'Stars';

  @override
  String get leaveComment => 'Leave Comment';

  @override
  String get userType => 'User Type';

  @override
  String get userProfile => 'User Profile';

  @override
  String get validationError => 'Validation Error';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidInput => 'Invalid Input';

  @override
  String get optional => 'Optional';

  @override
  String get required => 'Required';

  @override
  String get description => 'Description';

  @override
  String get problemDetails => 'Problem Details';

  @override
  String get attachPhotos => 'Attach Photos';

  @override
  String get summary => 'Summary';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get bookingSummary => 'Booking Summary';

  @override
  String get readySummary => 'Ready to get back on the road?';

  @override
  String get editPassword => 'Edit Password';

  @override
  String get savePassword => 'Save Password';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get creating => 'Creating...';

  @override
  String get enterFirstName => 'Enter first name';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get reEnterPassword => 'Re-enter password';

  @override
  String get addVehicleImage => 'Add vehicle image';

  @override
  String get tapToSelectImage => 'Tap to select image';

  @override
  String get selectVehicleImage => 'Please select a vehicle image';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get vehicleAddedSuccess => 'Vehicle added successfully';

  @override
  String get odometer => 'Odometer';

  @override
  String get licensePlateNumberFull => 'License plate number';

  @override
  String get serviceRecords => 'Service records';

  @override
  String get fuelRecords => 'Fuel records';

  @override
  String get plate => 'Plate';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get createYourAccount => 'Create Your Account';

  @override
  String get carReadyMessage => 'We’re here to keep your car in top shape. Are you ready?';

  @override
  String get sos => 'SOS';

  @override
  String get fuel => 'Fuel';

  @override
  String get notification => 'Notifications';

  @override
  String get messages => 'Messages';

  @override
  String get changedpasswordsuccessfully => 'The password has been successfully changed.';

  @override
  String get enterphone => 'Enter Phone';

  @override
  String get thepasswordsdonotmatch => ' The passwords do not match.';

  @override
  String get activeorders => 'Active Orders ';

  @override
  String get saveandfollow => 'Save and follow';

  @override
  String get savevehicle => 'Save Vehicle';

  @override
  String get parts => 'Spare Parts';

  @override
  String get details => ' عرض التفاصيل';

  @override
  String get updateCarsList => 'Updating car list...';

  @override
  String get noCarsYet => 'No cars yet';

  @override
  String get vehicleUpdatedSuccessfully => 'Vehicle updated successfully';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saving => 'Saving...';

  @override
  String get updateVehicle => 'Update Vehicle';

  @override
  String get deleteVehicle => 'Delete Vehicle';

  @override
  String get failedToLoadAds => 'Failed to load advertisements';

  @override
  String get invalidInputData => 'Invalid data input';

  @override
  String get deliveryTrackingTitle => 'Delivery Tracking';

  @override
  String get selectDeliveryLocationTitle => 'Select Delivery Location';

  @override
  String get myLocationLabel => 'My Location';

  @override
  String get moveMapToPickLocation => 'Move the map to pick the delivery location';

  @override
  String get confirmLocationButton => 'Confirm Location';

  @override
  String get invoiceDetails => 'Invoice Details';

  @override
  String get processingStatusLabel => 'Processing';

  @override
  String get outForDeliveryStatusLabel => 'Out for Delivery';

  @override
  String get deliveredStatusLabel => 'Delivered';

  @override
  String get rejectedStatusLabel => 'Rejected';

  @override
  String get allRequestsTitle => 'My Orders';

  @override
  String get shopLabel => 'Shop';

  @override
  String get noProductsAvailable => 'No products available';

  @override
  String plusMoreProductsLabel(int count) {
    return '+$count more items';
  }

  @override
  String get quantityLabel => 'Quantity';

  @override
  String addToCartWithPriceLabel(String price) {
    return 'Add to Cart — $price';
  }

  @override
  String get inStockStatus => 'In Stock';

  @override
  String get outOfStockStatus => 'Out of Stock';

  @override
  String productConditionLabel(String condition) {
    return 'Condition: $condition';
  }

  @override
  String productCategoryLabel(String category) {
    return 'Category: $category';
  }

  @override
  String productCarBrandLabel(String brand) {
    return 'Car Brand: $brand';
  }

  @override
  String discountPercentLabel(String percent) {
    return '$percent% OFF';
  }

  @override
  String inStockWithCountLabel(int count) {
    return 'In Stock ($count items)';
  }

  @override
  String get shopsTitle => 'Shops';

  @override
  String get cartLabel => 'Cart';

  @override
  String get shopDetailsPageTitle => 'Shop Information';

  @override
  String get businessTypeLabel => 'Business Type';

  @override
  String get carBrandsLabel => 'Car Brands';

  @override
  String get partCategoriesLabel => 'Part Categories';

  @override
  String get shopStorefrontPageTitle => 'Shop Storefront';

  @override
  String get sparePartsStoreTitle => 'Spare Parts Store';

  @override
  String get shareDeliveryLocationTitle => 'Share Delivery Location';

  @override
  String get startProcessingButton => 'Start Processing';

  @override
  String get startDeliveryButton => 'Start Delivery';

  @override
  String get confirmDeliveryButton => 'Confirm Delivery';

  @override
  String orderNumberLabel(String id) {
    return 'Order #$id';
  }

  @override
  String get orderCancelledSuccessMessage => 'Order has been cancelled successfully';

  @override
  String get tapToTrackFuelProviderLive => 'Tap to track fuel provider live';

  @override
  String get trackFuelProviderTitle => 'Track Fuel Provider';

  @override
  String get waitingFuelProviderAcceptance => 'Waiting for fuel provider acceptance';

  @override
  String get orderNotesTitle => 'Order Notes';

  @override
  String get fuelProviderHasNotSharedLocationYet => 'The fuel provider has not shared their location yet';

  @override
  String get avatarUpdatedSuccess => 'Profile picture updated successfully';

  @override
  String get accountDeletedSuccessMessage => 'Account deleted successfully';

  @override
  String get fuelLogTitle => 'Fuel Log';

  @override
  String costWithParamLabel(String cost) {
    return 'Cost: $cost';
  }

  @override
  String odometerReadingWithParamLabel(String km) {
    return 'Odometer: $km km';
  }

  @override
  String get brandRequiredError => 'Please enter the vehicle brand';

  @override
  String get brandMinLengthError => 'Brand must be at least 2 characters long';

  @override
  String get brandMaxLengthError => 'Brand is too long (maximum 50 characters)';

  @override
  String get brandInvalidCharsError => 'Brand contains unallowed symbols';

  @override
  String get modelRequiredError => 'Please enter the vehicle model';

  @override
  String get modelMaxLengthError => 'Model is too long (maximum 50 characters)';

  @override
  String get modelInvalidCharsError => 'Model contains unallowed symbols';

  @override
  String get plateNumberRequiredError => 'Please enter the plate number';

  @override
  String get plateInvalidCharsError => 'Plate number contains unallowed symbols';

  @override
  String get plateLengthError => 'Plate number must be between 4 and 9 characters';

  @override
  String get manufactureYearRequiredError => 'Please enter the manufacturing year';

  @override
  String get invalidYearError => 'Please enter a valid year';

  @override
  String yearRangeError(int maxYear) {
    return 'Manufacturing year must be between 1900 and $maxYear';
  }

  @override
  String get odometerRequiredError => 'Please enter the odometer reading';

  @override
  String get odometerRangeError => 'Odometer reading must be between 0 and 2000000';

  @override
  String get unsupportedImageFormatError => 'Unsupported image format (jpg, jpeg, png or webp only)';

  @override
  String get imageSizeExceededError => 'Image size must not exceed 5 MB';

  @override
  String get pleaseSelectVehicleImageError => 'Please select a vehicle image';

  @override
  String get defaultVehicleLabel => 'Vehicle';

  @override
  String get vehicleDeletedSuccess => 'Vehicle has been deleted successfully';

  @override
  String fuelAmountDetailsLabel(String type, String amount) {
    return '$type — $amount Liters';
  }

  @override
  String get gasoline98 => 'Gasoline 98';

  @override
  String get completeAllFieldsError => 'Please complete all fields';

  @override
  String get fuelOrderSentSuccessfully => 'Fuel order sent successfully';

  @override
  String get editButtonLabel => 'Edit';

  @override
  String ownerStockCountLabel(int count) {
    return 'Stock: $count';
  }

  @override
  String get addProduct => 'Add Product';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get productName => 'Product Name';

  @override
  String get productNameRequired => 'Product name is required';

  @override
  String get enterValidPrice => 'Enter a valid price';

  @override
  String get availableQuantity => 'Available Quantity';

  @override
  String get enterValidQuantity => 'Enter a valid quantity';

  @override
  String get classification => 'Classification';

  @override
  String get productCondition => 'Product Condition';

  @override
  String get carBrand => 'Car Brand';

  @override
  String get partCategory => 'Part Category';

  @override
  String get noSelection => 'No selection';

  @override
  String get productImages => 'Product Images';

  @override
  String get addImages => 'Add Images';

  @override
  String imagesCount(int count, int max) {
    return 'Images ($count/$max)';
  }

  @override
  String get confirmSelectionButtonLabel => 'Confirm Selection';

  @override
  String get shopProfilePageTitle => 'Store Profile';

  @override
  String get fillAllFieldsRequiredError => 'Please fill in all required fields';

  @override
  String get shopSavedSuccess => 'Store saved successfully';

  @override
  String get shopNameLabel => 'Store Name';

  @override
  String get shopNameHint => 'Enter store name';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get phoneNumberHint => 'Enter phone number';

  @override
  String get cityLabel => 'City';

  @override
  String get cityHint => 'Enter city name';

  @override
  String get activeStatus => 'Active';

  @override
  String get unknownStatus => 'Unspecified';

  @override
  String unknownProfileValuesError(String values) {
    return 'Unknown values in your profile: $values\nCannot save until these values are matched in the system.';
  }

  @override
  String get updateProduct => 'Update Store';

  @override
  String get chooseActionLabel => 'Choose';

  @override
  String get noSelectionMadeYet => 'No selection made yet';

  @override
  String confirmMultiSelectionCount(int count) {
    return 'Confirm Selection ($count)';
  }

  @override
  String get shopSpecializationsPageTitle => 'Store Specializations';

  @override
  String get specializationsUpdatedSuccess => 'Specializations updated successfully';

  @override
  String get inactiveStatus => 'Inactive';

  @override
  String get myJobsTitle => 'My Jobs';

  @override
  String get jobAssignedStatusLabel => 'Assigned';

  @override
  String get jobStatusUpdatedSuccess => 'Task status updated successfully';

  @override
  String get jobLoadErrorLabel => 'An error occurred while loading jobs';

  @override
  String get refreshOrdersLogHint => 'Updating requests log ...';

  @override
  String get clientLabel => 'Client';

  @override
  String get appointmentNotesLabel => 'Appointment Notes';

  @override
  String get startWorkButtonLabel => 'Start Work';

  @override
  String get endWorkButtonLabel => 'End Work';

  @override
  String get completeJobTitle => 'Complete Task';

  @override
  String get completionNotesLabel => 'Completion Notes';

  @override
  String get completionNotesHint => 'Type what has been accomplished...';

  @override
  String get completionNotesRequiredError => 'Completion notes are required';

  @override
  String get confirmCompletionButton => 'Confirm Completion';

  @override
  String get sendingRequest => 'Sending...';

  @override
  String get providerReviewPendingTitle => 'Your application is under review';

  @override
  String get providerReviewRejectedTitle => 'Application rejected';

  @override
  String get providerReviewPendingMessage => 'Your application is currently under review. We\'ll notify you once a decision is made.';

  @override
  String get providerReviewRejectedDefaultReason => 'Your application was rejected. Contact support for more details.';

  @override
  String get providerReviewDialogOk => 'OK';

  @override
  String get updatingProgress => 'Updating...';

  @override
  String get quotationPriceLabel => 'Price Offer';

  @override
  String get quotationSentWaitingApproval => 'Your offer has been sent — waiting for customer approval';

  @override
  String get submitQuotationButtonLabel => 'Submit Price Offer';

  @override
  String get quotationSubmittedSuccess => 'Offer submitted successfully';

  @override
  String get dateLabel => 'Date';

  @override
  String get customerDataTitle => 'Customer Information';

  @override
  String get malfunctionDetailsTitle => 'Malfunction Details';

  @override
  String get requestDateLabel => 'Request Date';

  @override
  String get statusLabel => 'Status';

  @override
  String get vehicleDataTitle => 'Vehicle Information';

  @override
  String get addTechnicianLabel => 'Add Technician';

  @override
  String get editTechnicianProfileLabel => 'Edit Technician Profile';

  @override
  String get technicianJoinRequestSuccess => 'Technician join request submitted successfully';

  @override
  String get certificationsSectionTitle => 'Certifications';

  @override
  String get maxThreeImagesHint => 'Maximum 3 images';

  @override
  String get workshopLocationSet => 'Workshop location set';

  @override
  String get selectWorkshopLocation => 'Select Workshop Location';

  @override
  String get myLocation => 'My Location';

  @override
  String get moveMapToSelectLocation => 'Move the map to set the correct location';

  @override
  String get savingInProgress => 'Saving...';

  @override
  String get confirmLocationAction => 'Confirm Location';

  @override
  String get currencySuffix => 'SYP';

  @override
  String get availableQuantityLabel => 'Available Quantity';

  @override
  String get saveChangesButtonLabel => 'Save Changes';

  @override
  String get availabilityStatusLabel => 'Availability Status';

  @override
  String get availableForWork => 'Available for Work';

  @override
  String get unavailableForWork => 'Unavailable for Work';

  @override
  String maxImagesLimitError(int count) {
    return 'You can select a maximum of $count images';
  }

  @override
  String get personalDataTitle => 'Personal Information';

  @override
  String get professionalDataTitle => 'Professional Information';

  @override
  String get hourlyRateLabel => 'Hourly Rate';

  @override
  String get mechanicLabel => 'Mechanic';

  @override
  String get electricityLabel => 'Electrician';

  @override
  String get paintLabel => 'Painting';

  @override
  String get tiresLabel => 'Tires';

  @override
  String get airConditioningLabel => 'Air Conditioning';

  @override
  String get plumbingLabel => 'Plumbing';

  @override
  String get profileLoadError => 'An error occurred while loading the profile';

  @override
  String get updateWorkshopLocationDescription => 'You can update the workshop location when needed';

  @override
  String get addNewCertificationsHint => 'You can add new certifications';

  @override
  String get professionalInfo => 'Professional Information';

  @override
  String get specialization => 'Specialization';

  @override
  String get experienceYears => 'Years of Experience';

  @override
  String get hourlyRate => 'Hourly Rate';

  @override
  String get contactInfo => 'Contact Information';

  @override
  String get certifications => 'Certifications';

  @override
  String get durationRequiredError => 'Please enter the expected duration';

  @override
  String get invalidNumberError => 'Please enter a valid number';

  @override
  String get durationRangeError => 'Duration must be between 1 and 30 days';

  @override
  String get enterExpectedPriceHint => 'Please enter the expected price...';

  @override
  String get durationInDaysLabel => 'Duration (in Days)';

  @override
  String get durationRangeHint => 'From 1 to 30 days';

  @override
  String get requiredPartsLabel => 'Required Parts';

  @override
  String get includedInPriceLabel => 'Included in Price';

  @override
  String get additionalPriceLabel => 'Additional Price';

  @override
  String get netEarningsLabel => 'Net Earnings';

  @override
  String get statusDetailsTitle => 'Status Details';

  @override
  String get assignedStatusLabel => 'Assigned';

  @override
  String get cancellationReasonRequired => 'Cancellation reason is required';

  @override
  String cancellationReasonMinLengthError(int count) {
    return 'The cancellation reason must be at least 5 characters long';
  }

  @override
  String get sosGenericActionError => 'An error occurred while performing the action, please try again';

  @override
  String sosStatusUpdatedWithLabel(String status) {
    return 'Status updated: $status';
  }

  @override
  String get startHeadingButtonLabel => 'Start Heading';

  @override
  String get acceptRequestToNavigateHint => 'Accept the request to start heading to the customer';

  @override
  String get headingToClientTitle => 'Heading to Customer';

  @override
  String get cancelResponseTitle => 'Cancel Response';

  @override
  String get cancelResponseLabel => 'Reason for cancelling response';

  @override
  String get cancelResponseHint => 'Type the reason for cancelling response...';

  @override
  String trackOrderWithIdLabel(String id) {
    return 'Tracking Order #$id';
  }

  @override
  String get confirmExitTitle => 'Confirm Exit';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get stopSharingLocationWarning => 'Your location sharing will stop. Do you want to exit?';

  @override
  String get exitActionLabel => 'Exit';

  @override
  String get jobCompletedSuccessMessage => 'Order completed successfully ✓';

  @override
  String get writeAdditionalNotesHint => 'Write any additional notes...';

  @override
  String get sendQuotationActionLabel => 'Send Offer';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully ✓';

  @override
  String get noCertificatesUploaded => 'No certificates uploaded yet';

  @override
  String get workshopLocationTitle => 'Workshop Location';

  @override
  String get workshopLocationDescriptionHint => 'Select your workshop location to appear to nearby customers';

  @override
  String vehicleLabelWithParam(Object brand, Object model) {
    return '$brand $model';
  }

  @override
  String get productAddedSuccessfully => 'Product added successfully';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get ownerProductsPageTitle => 'Store Products';

  @override
  String sosRequestCreatedAgo(String time) {
    return 'Created $time ago';
  }

  @override
  String get sosAcceptingInProgress => 'Accepting...';

  @override
  String get sosAcceptRequest => 'Accept Request';

  @override
  String get sosProcessingInProgress => 'Processing...';

  @override
  String get sosStartProgress => 'Start Progress';

  @override
  String get sosFinishRequest => 'Finish Request';

  @override
  String get sosCancelResponse => 'Cancel Response';

  @override
  String get sosChangeStatusTitle => 'Change Request Status';

  @override
  String get sosInProgressStatus => 'In Progress';

  @override
  String get sosCompletedStatus => 'Completed';

  @override
  String get sosNavigateToCustomer => 'Navigate to Customer';

  @override
  String get sosUpdatingInProgress => 'Updating...';

  @override
  String get shopOrdersPageTitle => 'Store Orders';

  @override
  String get statusUpdatedSuccessMessage => 'Request status updated successfully';

  @override
  String statusUpdatedWithDynamicLabel(String status) {
    return 'Status updated: $status';
  }

  @override
  String get sosStatusUpdated => 'Request status updated';

  @override
  String get sosCustomerLocation => 'Customer Location';

  @override
  String get sosStartNavigateToCustomer => 'Start navigating to customer';

  @override
  String get sosAcceptToNavigateHint => 'Accept the request to start navigating to the customer';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String sosLocationSendError(String message) {
    return 'Error sending location: $message';
  }

  @override
  String get customerLabel => 'Customer';

  @override
  String get youLabel => 'You';

  @override
  String distanceInMeters(String value) {
    return '$value m';
  }

  @override
  String distanceInKm(String value) {
    return '$value km';
  }

  @override
  String get sharingLocationActive => 'Sharing your location with the customer';

  @override
  String get locatingInProgress => 'Locating...';

  @override
  String get calculatingRouteInProgress => 'Calculating route...';

  @override
  String distanceToCustomer(String distance) {
    return 'Distance to customer';
  }

  @override
  String get conditionNew => 'New';

  @override
  String get conditionUsed => 'Used';

  @override
  String get productImageLabel => 'Product Image';

  @override
  String get allProductsPageTitle => 'All Products';

  @override
  String get productDetailsTitle => 'Product Details';

  @override
  String get productAddedToCartSuccess => 'Product added to cart successfully';

  @override
  String get viewCartButton => 'View Cart';

  @override
  String get cancelOrderFormHint => 'e.g., I no longer need this order';

  @override
  String get orderDetailsTitle => 'Order Details';

  @override
  String get orderNumberLabel1 => 'Order Number';

  @override
  String get cancellableLabel => 'Cancellable';

  @override
  String get rejectOrderFormHint => 'e.g., Product is currently out of stock';

  @override
  String get confirmRejectionButton => 'Confirm Rejection';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Theme';

  @override
  String get arabicLabel => 'العربية';

  @override
  String get englishLabel => 'English';

  @override
  String get lightModeLabel => 'Light';

  @override
  String get darkModeLabel => 'Dark';

  @override
  String get systemModeLabel => 'System';

  @override
  String get productsLabel => 'Products';

  @override
  String get deliveryLabel => 'Delivery';

  @override
  String get grandTotalLabel => 'Grand Total';

  @override
  String get trackDeliveryButton => 'Track Delivery';

  @override
  String get cancelOrderButton => 'Cancel Order';

  @override
  String get invoiceNumber => 'Invoice Number';

  @override
  String get invoicePeriod => 'Period';

  @override
  String get invoiceTotal => 'Total';

  @override
  String get invoiceSubtotal => 'Subtotal';

  @override
  String get invoiceCommission => 'Commission';

  @override
  String get invoiceSubscription => 'Subscription';

  @override
  String get invoiceStatus => 'Status';

  @override
  String get invoicePaidAt => 'Payment Date';

  @override
  String get invoiceItems => 'Invoice Items';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusIssued => 'Issued';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusPaid => 'Paid';

  @override
  String get confirmDeleteTitle => 'Confirm Deletion';

  @override
  String get confirmDeleteMessage => 'Are you sure you want to delete this vehicle?\nThis action cannot be undone.';

  @override
  String get owner => 'Owner';

  @override
  String get km => 'km';

  @override
  String get maintenanceRecord => 'Maintenance Record';

  @override
  String get fuelRecord => 'Fuel Record';

  @override
  String get alertsRecord => 'Alerts Record';

  @override
  String get totalJobs => 'Total jobs';

  @override
  String get assignedJobs => 'Assigned';

  @override
  String get inProgressJobs => 'In progress';

  @override
  String get completedJobs => 'Completed';

  @override
  String get totalQuotations => 'Total quotations';

  @override
  String get pendingQuotations => 'Pending quotations';

  @override
  String get acceptedQuotations => 'Accepted quotations';

  @override
  String get totalRatings => 'Total ratings';

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String get confirmDeleteProfileTitle => 'Confirm Deletion';

  @override
  String get confirmDeleteProfileMessage => 'Are you sure you want to delete your account?\nThis action cannot be undone.';

  @override
  String get profileDeletedSuccessfully => 'Profile deleted successfully';

  @override
  String get enterPhone => 'Please enter phone number';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get enterAsTechnician => 'Enter as technician';

  @override
  String get washersPageTitle => 'Car washes';

  @override
  String get washersByCity => 'By city';

  @override
  String get washersBookAppointment => 'Book an appointment';

  @override
  String get washersViewDetails => 'View details';

  @override
  String washersCityWithName(String cityName) {
    return 'City: $cityName';
  }

  @override
  String washersRatingsWithCount(int count) {
    return 'Ratings: $count';
  }

  @override
  String get washerTierBasic => 'BASIC';

  @override
  String get washerTierVip => 'VIP';

  @override
  String get washerTierPremium => 'PREMIUM';

  @override
  String get washerDetailsTitle => 'Car wash details';

  @override
  String washerOpenTime(String time) {
    return 'Open: $time';
  }

  @override
  String washerCloseTime(String time) {
    return 'Close: $time';
  }

  @override
  String get washerSectionCityAndAddress => 'City and address';

  @override
  String get washerSectionServicesAndPrices => 'Services and prices';

  @override
  String get washerSectionCustomerReviews => 'Customer reviews';

  @override
  String get washerServiceExterior => 'Exterior';

  @override
  String get washerServiceInterior => 'Interior';

  @override
  String get washerServiceEngine => 'Engine';

  @override
  String washerPackagePrice(int amount) {
    return 'price: $amount \$';
  }

  @override
  String get washerReservationTitle => 'Reservation';

  @override
  String get washerReservationFieldDate => 'Date';

  @override
  String get washerReservationFieldTime => 'Time';

  @override
  String get washerReservationFieldVehicleLabel => 'Enter your vehicle type';

  @override
  String get washerReservationFieldVehicleHint => 'Type your vehicle here';

  @override
  String get washerReservationFieldNotesLabel => 'Notes';

  @override
  String get washerReservationFieldNotesHint => 'Add any notes you want';

  @override
  String get washerReservationChooseService => 'Choose the right service';

  @override
  String get washerReservationConfirm => 'Confirm reservation';

  @override
  String get washerReservationCancel => 'Cancel reservation';

  @override
  String get washerReservationPickDate => 'Pick a date';

  @override
  String get washerReservationPickTime => 'Pick a time';

  @override
  String get washerReservationServicePremium => 'Premium';

  @override
  String get washerReservationServiceVip => 'Vip';

  @override
  String get washerReservationServiceBasic => 'Basic';

  @override
  String get bookingsPageTitle => 'My Reserved';

  @override
  String get bookingsFilterByStatus => 'By status';

  @override
  String get washerNoVehiclesMessage => 'You don\'t have any vehicles. Please add a vehicle first from the My Vehicles page.';

  @override
  String get washerSelectVehicleMessage => 'Please select a vehicle';

  @override
  String get washerSelectDateTimeMessage => 'Please select a date and time';

  @override
  String get washerBookingSuccessMessage => 'Booking completed successfully';

  @override
  String get loadingYourVehicles => 'Loading your vehicles...';

  @override
  String get noVehiclesAdded => 'No vehicles added';

  @override
  String get selectYourVehicle => 'Select your vehicle';

  @override
  String get bookingStatusesTitle => 'Booking Statuses';

  @override
  String get pleaseEnterCancellationReason => 'Please enter the reason for cancellation';

  @override
  String get orderAcceptedSuccess => 'Order accepted successfully';

  @override
  String get orderStartedSuccess => 'Order execution started successfully';

  @override
  String get orderCompletedSuccess => 'Order completed successfully';

  @override
  String get orderCancelledSuccess => 'Order cancelled successfully';

  @override
  String get cancelFuelOrderTitle => 'Cancel Fuel Order';

  @override
  String get ratingsTitle => 'Ratings';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String get showMore => 'Show More';

  @override
  String get defaultUserName => 'User';

  @override
  String ratingsCountLabel(int count) {
    return '($count reviews)';
  }

  @override
  String currencyFormat(String amount) {
    return '\$$amount';
  }

  @override
  String get shareLocationTitle => 'Share Location';

  @override
  String get shareLocationDescription => 'Select an in-progress fuel order from my orders to share your location';

  @override
  String get goToMyOrders => 'Go to My Orders';

  @override
  String get orderStatusesTitle => 'Order Statuses';

  @override
  String get homeWelcomeGreeting => '- How can we help you today? -';

  @override
  String get quotationDetailsTitle => 'Offer Details';

  @override
  String get quotationAcceptedSuccess => 'Offer accepted successfully';

  @override
  String get quotationRejectedSuccess => 'Offer rejected';

  @override
  String get quotationsTitle => 'Price Quotations';

  @override
  String get noQuotationsAvailable => 'No price quotations available';

  @override
  String get acceptQuotationTitle => 'Accept Quotation';

  @override
  String get selectedDateLabel => 'Selected Date';

  @override
  String get chooseDateLabel => 'Choose Date';

  @override
  String get notesLabel => 'Notes';

  @override
  String get confirmLabel => 'Confirm';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get technicianLabel => 'Technician';

  @override
  String get repairDurationLabel => 'Repair Duration';

  @override
  String get partsIncludedLabel => 'Parts Included';

  @override
  String durationInDays(int count) {
    return '$count Days';
  }

  @override
  String get cannotShareLocationOrderFinished => 'Cannot share location for a finished or cancelled order';

  @override
  String get enableLocationServiceMessage => 'Please enable location services in device settings';

  @override
  String get locationPermissionDeniedForever => 'Location permission permanently denied, please enable it from app settings';

  @override
  String get locationPermissionRequired => 'Location permission is required to share your location with the customer';

  @override
  String get unableToDetermineLocation => 'Unable to determine your current location, please try again';

  @override
  String get genericErrorTryAgain => 'An error occurred, please try again';

  @override
  String get errorSendingLocation => 'Error sending location';

  @override
  String get deliveryLocation => 'Delivery Location';

  @override
  String get you => 'You';

  @override
  String get sharingLocationWithCustomer => 'Sharing your location with the customer';

  @override
  String get determiningLocation => 'Determining location...';

  @override
  String get calculatingRoute => 'Calculating route...';

  @override
  String get meterUnit => 'm';

  @override
  String get kmUnit => 'km';

  @override
  String get technicianInfoCardTitle => 'Technician Information';

  @override
  String get specializationLabel => 'Specialization';

  @override
  String get experienceYearsLabel => 'Years of Experience';

  @override
  String get quotationDateLabel => 'Quotation Date';

  @override
  String get technicianNotesCardTitle => 'Technician Notes';

  @override
  String get acceptQuotationButton => 'Accept Offer';

  @override
  String get rejectQuotationButton => 'Reject Offer';

  @override
  String get rejectQuotationReasonTitle => 'Reason for Rejection';

  @override
  String durationInYears(int count) {
    return '$count Years';
  }

  @override
  String get maintenanceRequestDetailsTitle => 'Maintenance Request Details';

  @override
  String get unexpectedErrorTryAgain => 'An error occurred during execution, please try again';

  @override
  String get add => 'Add';

  @override
  String get selectPreferredDateTitle => 'Select Preferred Date';

  @override
  String get selectPriorityTitle => 'Select Priority';

  @override
  String get problemDescriptionTitle => 'Problem Description';

  @override
  String get problemDescriptionHint => 'Please type the details of the problem here...';

  @override
  String get noVehicleSelectedPrompt => 'No vehicle selected';

  @override
  String get changeVehicleButton => 'Change Vehicle';

  @override
  String kilometerCountLabel(int count) {
    return '$count km';
  }

  @override
  String get descriptionLabel => 'Description';

  @override
  String get vehicleLabel => 'Vehicle';

  @override
  String get appointmentLabel => 'Appointment';

  @override
  String get confirmCancellationButton => 'Confirm Cancellation';

  @override
  String get backButton => 'Back';

  @override
  String get cancellationReason => 'Cancellation Reason';

  @override
  String get bookingsCancelReasonHint => 'Type cancellation reason...';

  @override
  String get cancelRequestButton => 'Cancel Request';

  @override
  String get deleteRequestTitle => 'Delete Request';

  @override
  String get deleteRequestConfirmation => 'Are you sure you want to delete this request?';

  @override
  String get cannotUndoActionWarning => 'This action cannot be undone';

  @override
  String get yesDeleteButton => 'Yes, Delete';

  @override
  String get requestDeletedSuccess => 'Request deleted successfully';

  @override
  String get cancellingProgress => 'Cancelling...';

  @override
  String get deletingProgress => 'Deleting...';

  @override
  String quotationsCountLabel(int count) {
    return 'Offers ($count)';
  }

  @override
  String get requestImagesTitle => 'Request Images';

  @override
  String get requestInfoCardTitle => 'Request Data';

  @override
  String get preferredDateLabel => 'Preferred Date';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get creationDateLabel => 'Creation Date';

  @override
  String get technicianLocationTitle => 'Technician Location';

  @override
  String get plateNumberLabel => 'Plate Number';

  @override
  String get mileageLabel => 'Mileage';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get noVehiclesAddOneFirst => 'You have no vehicles, please add one first from My Vehicles';

  @override
  String get maxThreeImagesAllowed => 'You can select up to 3 images';

  @override
  String get pleaseSelectVehicleFirst => 'Please select a vehicle first';

  @override
  String get pleaseDescribeProblem => 'Please describe the problem';

  @override
  String get internalError => 'Internal error';

  @override
  String get requestSentSuccessfully => 'Request sent successfully';

  @override
  String get maintenanceRequestTitle => 'Maintenance Request';

  @override
  String fuelAmountLabel(String type, num amount) {
    return '$type - $amount Liters';
  }

  @override
  String get all => 'All';

  @override
  String get pleaseEnterRejectionReason => 'Please enter the reason for rejection';

  @override
  String get otherServices => 'Other Services';

  @override
  String get washerAvailabilityUpdateSuccess => 'Availability status updated successfully';

  @override
  String get washerAvailabilityTitle => 'Available for bookings';

  @override
  String get washerAvailabilityStatusAvailable => 'Currently available';

  @override
  String get washerAvailabilityStatusUnavailable => 'Currently unavailable';

  @override
  String get send => 'Send';

  @override
  String get profileWasherDefaultServices => 'Normal Wash, Premium Wash, Polishing';

  @override
  String get pleaseEnterShopName => 'Please enter the car wash name';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter the phone number';

  @override
  String get pleaseEnterCity => 'Please enter the city';

  @override
  String get profileWasherCreateSuccessMessage => 'Car wash profile created successfully';

  @override
  String get profileWasherEditSuccessMessage => 'Changes saved successfully';

  @override
  String get allGovernorates => 'All Governorates';

  @override
  String get filterByGovernorate => 'By Governorate';

  @override
  String get damascus => 'Damascus';

  @override
  String get rifDimashq => 'Rif Dimashq';

  @override
  String get aleppo => 'Aleppo';

  @override
  String get homs => 'Homs';

  @override
  String get hama => 'Hama';

  @override
  String get latakia => 'Latakia';

  @override
  String get tartus => 'Tartus';

  @override
  String get idlib => 'Idlib';

  @override
  String get daraa => 'Daraa';

  @override
  String get asSuwayda => 'As-Suwayda';

  @override
  String get quneitra => 'Quneitra';

  @override
  String get deirEzZor => 'Deir ez-Zor';

  @override
  String get raqqa => 'Raqqa';

  @override
  String get alHasakah => 'Al-Hasakah';

  @override
  String get bookingStatusPinding => 'pinding';

  @override
  String get bookingsWasherName => 'Al-Miqdad Car Wash';

  @override
  String get bookingsServiceLabel => 'Requested service';

  @override
  String get bookingsServiceVip => 'Vip';

  @override
  String get bookingsDateTimeLabel => 'Date';

  @override
  String get bookingsAtLabel => 'at';

  @override
  String get bookingsPriceLabel => 'Price';

  @override
  String get bookingsMenuShowDetails => 'Show details';

  @override
  String get washerBookingViewDetails => 'View details';

  @override
  String get washerBookingAccept => 'Accept';

  @override
  String get washerBookingReject => 'Reject';

  @override
  String get washerBookingStartExecution => 'Start execution';

  @override
  String get washerBookingCompleted => 'Completed';

  @override
  String get washerBookingCustomerNameLabel => 'Customer name:';

  @override
  String get washerBookingRequestedServiceLabel => 'Requested service:';

  @override
  String get washerBookingAppointmentLabel => 'Appointment:';

  @override
  String get bookingsMenuCancelBooking => 'Cancel booking';

  @override
  String get bookingsMenuRateService => 'Rate service';

  @override
  String get bookingDetailsPageTitle => 'Booking details';

  @override
  String get bookingDetailsServiceSectionTitle => 'Service details';

  @override
  String get bookingDetailsAppointmentSectionTitle => 'Appointment details';

  @override
  String get bookingDetailsUserNotesSectionTitle => 'User notes';

  @override
  String get bookingDetailsWasherNameLabel => 'Car wash name';

  @override
  String get bookingDetailsOrderDateLabel => 'Order date';

  @override
  String get bookingDetailsVehicleLabel => 'Vehicle';

  @override
  String get ratingsServiceInfoSectionTitle => 'Service information';

  @override
  String get ratingsYourRatingQuestion => 'What is your rating for this service?';

  @override
  String get ratingsTellUsExperienceTitle => 'Tell us about your experience';

  @override
  String get ratingsCommentExperienceHint => 'Leave us a comment about your experience';

  @override
  String get ratingsSendRating => 'Send rating';

  @override
  String get profileWasherPageTitle => 'Washer Profile';

  @override
  String get profileWasherEditProfile => 'Edit profile';

  @override
  String get profileWasherSampleShopName => 'Mahaba Car Wash';

  @override
  String profileWasherRatingsCountLine(int count) {
    return '$count ratings';
  }

  @override
  String get profileWasherSampleFullAddress => 'Damascus - Abbasiyyin Square - Entrance to Al-Qusour Square';

  @override
  String get profileWasherSamplePhone => '0987654321';

  @override
  String get profileWasherAboutTitle => 'About the wash';

  @override
  String get profileWasherDescriptionSample => 'At Mahaba Car Wash we deliver professional cleaning with safe, eco-friendly products and a crew that cares about every detail, inside and out. We strive to serve you day after day with clear pricing and a comfortable wait—because your car deserves spotless care from people who love doing the job right.';

  @override
  String get profileWasherEditPageTitle => 'Edit washer profile';

  @override
  String get profileWasherFieldWasherName => 'Washer name';

  @override
  String get profileWasherHintWasherName => 'Enter wash name';

  @override
  String get profileWasherFieldPhone => 'Phone number';

  @override
  String get profileWasherHintPhone => 'Enter contact phone number';

  @override
  String get profileWasherFieldAddress => 'City and address';

  @override
  String get profileWasherHintAddress => 'Enter full wash address';

  @override
  String get profileWasherFieldWorkStart => 'Opening time';

  @override
  String get profileWasherHintWorkStart => 'Enter opening time';

  @override
  String get profileWasherFieldWorkEnd => 'Closing time';

  @override
  String get profileWasherHintWorkEnd => 'Enter closing time';

  @override
  String get profileWasherChooseServicesTitle => 'Choose the services you offer';

  @override
  String get profileWasherFieldDescription => 'Description';

  @override
  String get profileWasherHintDescription => 'Enter wash description';

  @override
  String get profileWasherTierBasic => 'Basic';

  @override
  String get profileWasherTierVip => 'Vip';

  @override
  String get profileWasherTierPremium => 'Premium';

  @override
  String get profileWasherFieldPrice => 'Price';

  @override
  String get profileWasherHintPrice => 'Enter price';

  @override
  String get profileWasherSaveChanges => 'Save changes';

  @override
  String get profileWasherCreatePageTitle => 'Create washer profile';

  @override
  String get profileWasherUploadLogo => 'Upload logo';

  @override
  String get profileWasherFieldCity => 'City';

  @override
  String get profileWasherHintCity => 'Enter city';

  @override
  String get profileWasherFieldStreetAddress => 'Address';

  @override
  String get profileWasherHintStreetAddress => 'Enter address';

  @override
  String get profileWasherFieldServicesList => 'Services';

  @override
  String get profileWasherHintServicesList => 'Separate services with a comma';

  @override
  String get profileWasherWorkingHoursTitle => 'Working hours';

  @override
  String get profileWasherFieldSaturdayHours => 'Saturday';

  @override
  String get profileWasherHintSaturdayHours => 'e.g. 11:00-15:00';

  @override
  String get profileWasherFieldSundayHours => 'Sunday';

  @override
  String get profileWasherHintSundayHours => 'e.g. 10:00-16:00';

  @override
  String get profileWasherCreateSave => 'Save profile';

  @override
  String get showRatingTotalBookings => 'Total bookings';

  @override
  String get showRatingAllReserved => 'All Reserved';

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusAccepted => 'Accepted';

  @override
  String get bookingStatusProgress => 'In Progress';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusCanceled => 'Canceled';

  @override
  String get showRatingAverageRatings => 'Average ratings';

  @override
  String get showRatingUsersComments => 'Users comments';

  @override
  String get createSosTitle => 'Create SOS';

  @override
  String get createSosChooseVehicle => 'Choose the vehicle';

  @override
  String get createSosChooseProvince => 'Choose the province';

  @override
  String get createSosLocationAutoHint => '* Your current location will be sent automatically';

  @override
  String get createSosProblemDescription => 'Enter a description of the problem';

  @override
  String get createSosSendRequest => 'Send request';

  @override
  String get createSosSampleProblemText => 'Enter the description here';

  @override
  String get fuelSosCreateTitle => 'Fuel SOS Create';

  @override
  String get fuelSosCreateVehicleTitle => 'Vehicle';

  @override
  String get fuelSosCreateVehicleHint => 'Choose the vehicle you want for the service';

  @override
  String get fuelSosCreateFuelTypeTitle => 'Fuel type';

  @override
  String get fuelSosCreateFuelTypeHint => 'Choose the fuel type you want';

  @override
  String get fuelSosCreateQuantityTitle => 'Quantity';

  @override
  String get fuelSosCreateQuantityHint => 'Enter the quantity you want to fill';

  @override
  String get fuelSosCreateNotesTitle => 'Notes';

  @override
  String get fuelSosCreateNotesHint => 'Enter any notes you want to add';

  @override
  String get fuelSosCreateProvinceTitle => 'Governorate';

  @override
  String get fuelSosCreateProvinceHint => 'Choose the governorate at your current location';

  @override
  String get fuelSosCreateSelectVehicleRequired => 'Please select a vehicle';

  @override
  String get fuelSosCreateSelectFuelTypeRequired => 'Please select a fuel type';

  @override
  String get fuelSosCreateQuantityRequired => 'Please enter the quantity';

  @override
  String get fuelSosCreateSelectProvinceRequired => 'Please select a governorate';

  @override
  String get fuelSosCreateNoVehicles => 'No vehicles found';

  @override
  String get sosRequestsListTitle => 'SOS Requests List';

  @override
  String get sosRequestIdLabel => 'ID Number';

  @override
  String get sosRequestVehicleLabel => 'Vehicle';

  @override
  String get sosRequestShortDescriptionLabel => 'Short description';

  @override
  String get sosStatusFinished => 'Finished';

  @override
  String get sosStatusInProgress => 'In progress';

  @override
  String get sosStatusWaiting => 'Waiting';

  @override
  String get sosRequestAccept => 'Accept';

  @override
  String get sosRequestViewDetails => 'View details';

  @override
  String sosRequestCreatedAtHours(int hours) {
    return 'Created $hours hours ago';
  }

  @override
  String sosRequestCreatedAtMinutes(int minutes) {
    return 'Created $minutes min ago';
  }

  @override
  String get sosDetailsTitle => 'SOS Details';

  @override
  String get sosDetailsRequestAccepted => 'Request accepted';

  @override
  String get sosDetailsRequestData => 'Request data';

  @override
  String get sosDetailsPlateNumberLabel => 'Plate number';

  @override
  String get sosDetailsTechnicianLabel => 'Technician';

  @override
  String get sosDetailsDescriptionLabel => 'Description';

  @override
  String get sosDetailsCurrentLocation => 'Current location';

  @override
  String get sosDetailsTrack => 'Track';

  @override
  String get sosDetailsCancelRequest => 'Cancel request';

  @override
  String get fuelOrdersListTitle => 'Fuel Orders List';

  @override
  String get fuelOrderDetailsTitle => 'Fuel Order Details';

  @override
  String get fuelOrderDetailsProviderSection => 'Service provider details';

  @override
  String get cancelReasonDialogTitle => 'Cancel SOS';

  @override
  String get cancelReasonDialogQuestion => 'What is the reason for canceling the order?';

  @override
  String get cancelReasonDialogHint => 'Enter the reason for canceling the fuel order here...';

  @override
  String get cancelReasonDialogBack => 'Back';

  @override
  String get fuelCancelReasonDialogTitle => 'Cancel order';

  @override
  String get providerProfilePageTitle => 'Provider Profile';

  @override
  String get providerProfileAvailabilityTitle => 'Work availability';

  @override
  String get providerProfileAvailableNow => 'Available now';

  @override
  String get providerProfileNotAvailableNow => 'Not available now';

  @override
  String get providerProfileLocationSectionTitle => 'Service provider location';

  @override
  String get providerProfileServicesAndPricesTitle => 'Services and prices';

  @override
  String get providerProfileSampleName => 'Khaled Al-Khaled';

  @override
  String providerProfilePriceLine(String price) {
    return 'price : $price \$';
  }

  @override
  String get providerEditProfilePageTitle => 'Edit provider profile';

  @override
  String get providerEditProfilePersonalInfoTitle => 'Your profile information';

  @override
  String get providerEditProfileProviderNameLabel => 'Service provider name';

  @override
  String get providerEditProfileProviderNameHint => 'Enter the service provider name';

  @override
  String get providerEditProfileProviderPhoneLabel => 'Service provider phone';

  @override
  String get providerEditProfileProviderPhoneHint => 'Enter the service provider phone';

  @override
  String get providerEditProfileGovernorateLabel => 'Choose service provider governorate';

  @override
  String get providerEditProfileGovernorateHint => 'Choose governorate';

  @override
  String get providerEditProfileAddressLabel => 'Address';

  @override
  String get providerEditProfileAddressHint => 'Enter the full address';

  @override
  String get providerEditProfileLocationNote => '* Your location will be used as the provider starting point';

  @override
  String get providerEditProfileActivateServiceLine => 'Activate service and set price';

  @override
  String get providerEditProfileSaveInfo => 'Save information';

  @override
  String get providerEditProfileSampleAddress => 'Abbasiyeen Square - Al-Qusour Square entrance';

  @override
  String get providerCreateProfilePageTitle => 'Create provider profile';

  @override
  String get providerCreateProfileSave => 'Create profile';

  @override
  String providerEditProfileSetPriceTitle(String fuelType) {
    return 'Set price for $fuelType';
  }

  @override
  String get providerEditProfileSetPriceHint => 'Enter the price';

  @override
  String get providerEditProfileSetPriceRequired => 'Please enter a price';

  @override
  String get providerAvailableOrdersTitle => 'Available orders';

  @override
  String get providerAvailableOrderNoNotes => 'None';

  @override
  String get providerOrderDetailsTitle => 'Provider order details';

  @override
  String get providerOrderDetailsPendingAcceptance => 'Waiting for order acceptance';

  @override
  String get providerOrderDetailsCustomerSection => 'Customer details';

  @override
  String get providerOrderDetailsAcceptOrder => 'Accept order';

  @override
  String get providerOrderDetailsShareLocationOn => 'Share location';

  @override
  String get providerOrderDetailsShareLocationOff => 'Do not share location';

  @override
  String get providerOrderDetailsEstimatedArrivalDialogTitle => 'Estimated arrival minutes';

  @override
  String get providerOrderDetailsEnterDurationMinutes => 'Enter duration in minutes';

  @override
  String get providerOrderDetailsEnterAdditionalNotes => 'Enter additional notes';

  @override
  String get providerMyOrdersTitle => 'My orders';

  @override
  String get providerStatisticsTotalOrdersTitle => 'Total orders';

  @override
  String get providerStatisticsTotalProfitsTitle => 'Total profits';

  @override
  String get providerStatisticsAllOrders => 'All Reserved';

  @override
  String get advertisementSemanticLabel => 'Advertisement';

  @override
  String advertisementSemanticLabelWithTitle(String title) {
    return 'Advertisement: $title';
  }

  @override
  String get advertisementLinkOpenFailed => 'Couldn\'t open the advertisement link';

  @override
  String get requestStatusPending => 'Pending';

  @override
  String get requestStatusAccepted => 'Accepted';

  @override
  String get requestStatusCompleted => 'Completed';

  @override
  String get requestStatusAll => 'All';

  @override
  String get orderStatusAll => 'All';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusAccepted => 'Accepted';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusOutForDelivery => 'Out for Delivery';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusRejected => 'Rejected';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusAll => 'All';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get enterYourEmailHint => 'Enter your email';

  @override
  String get sendVerificationCode => 'Send verification code';

  @override
  String get otpCardTitle => 'Verification Code';

  @override
  String get otpSentDescription => 'We sent a 6-digit verification code to';

  @override
  String get confirmOtp => 'Confirm';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordButton => 'Change Password';

  @override
  String get invalidVerificationCode => 'Invalid verification code';

  @override
  String get verificationCodeExpired => 'Verification code expired';

  @override
  String get tooManyAttempts => 'Too many attempts';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get otpExpiresIn => 'Code expires in';

  @override
  String get otpExpiredNotice => 'The code has expired, please request a new one.';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get notificationsAllFilter => 'All';

  @override
  String get notificationsUnreadFilter => 'Unread';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get deleteNotification => 'Delete';

  @override
  String get notificationJustNow => 'Just now';

  @override
  String notificationMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String notificationHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get notificationYesterday => 'Yesterday';

  @override
  String notificationDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get selectGovernorate => 'Select governorate';

  @override
  String get readygSummary => 'Ready to get back on the road?';

  @override
  String get noChangesMadeError => 'No changes were made';

  @override
  String get completeOrderButton => 'Complete Order';

  @override
  String get dataSavedSuccess => 'Data saved';

  @override
  String get tapToStartHeadingHint => 'Tap to start heading and share your location';

  @override
  String get expectedDurationMinutesRangeError => 'Duration must be between 1 and 120 minutes';

  @override
  String get notesMaxLengthError => 'Notes must not exceed 500 characters';

  @override
  String get deliveryInfoTitle => 'Delivery Information';

  @override
  String get splashTagline => 'Your Complete Car Care Solution';

  @override
  String rejectionReasonPrefix(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get providerReviewSuspendedTitle => 'Your account has been suspended';

  @override
  String get providerReviewSuspendedMessage => 'Please contact support for more details.';

  @override
  String get enterAsCarWasher => 'Enter as car washer';

  @override
  String get enterAsFuelProvider => 'Enter as fuel provider';

  @override
  String get enterAsShopOwner => 'Enter as shop owner';

  @override
  String get bookingCancelledSuccess => 'Booking cancelled successfully';

  @override
  String get actionCompletedSuccess => 'Action completed successfully';

  @override
  String get ratingSubmittedSuccess => 'Rating submitted successfully';

  @override
  String get youMarkerLabel => 'You';

  @override
  String get waitingForDeliveryToStart => 'Waiting for delivery to start...';

  @override
  String get deliveryTrackingEnded => 'Tracking ended';

  @override
  String get deliverySuccessBanner => 'Delivered successfully';

  @override
  String get yourLocationMarkerLabel => 'Your Location';

  @override
  String get deliveryAgentLabel => 'Delivery Agent';

  @override
  String get orderRejectedSuccess => 'Order rejected';

  @override
  String get connectionTimeoutError => 'Connection timeout, please try again';

  @override
  String get sessionExpiredError => 'Your session has expired, please log in again';

  @override
  String get invalidCredentialsError => 'Invalid email or password';

  @override
  String get registrationFailedError => 'Registration failed, please check your information';

  @override
  String get googleSignInFailedError => 'Google sign-in failed, please try again';

  @override
  String get suspendedStatusLabel => 'Suspended';

  @override
  String get failedToLoadData => 'Failed to load data, please try again';

  @override
  String get failedToSaveChanges => 'Failed to save changes, please try again';

  @override
  String get failedToCancel => 'Failed to cancel, please try again';

  @override
  String get failedToUpdate => 'Failed to update, please try again';

  @override
  String get failedToDelete => 'Failed to delete, please try again';

  @override
  String get failedToCreate => 'Failed to complete the request, please try again';

  @override
  String get failedToAccept => 'Failed to accept, please try again';

  @override
  String get failedToReject => 'Failed to reject, please try again';

  @override
  String get failedToSubmit => 'Failed to submit, please try again';

  @override
  String get sparePartsBusinessType1 => 'Used Parts / Salvage';

  @override
  String get sparePartsBusinessType2 => 'Tires & Rims';

  @override
  String get sparePartsBusinessType3 => 'New Parts';

  @override
  String get sparePartsBusinessType4 => 'Batteries & Oils';

  @override
  String get sparePartsBusinessType5 => 'Accessories & Decor';

  @override
  String get sparePartsBusinessType6 => 'Oils & Filters';

  @override
  String get sparePartsBusinessType7 => 'Car Electrics';

  @override
  String get sparePartsBusinessType8 => 'Body & Chassis Parts';

  @override
  String get sparePartsBusinessType9 => 'Engine Parts';

  @override
  String get sparePartsBusinessType10 => 'Salvage Yard Services';

  @override
  String get sparePartsPartCategory1 => 'Brakes & Discs';

  @override
  String get sparePartsPartCategory2 => 'Clutch & Pressure Plate';

  @override
  String get sparePartsPartCategory3 => 'Body & Sheet Metal';

  @override
  String get sparePartsPartCategory4 => 'General Mechanics';

  @override
  String get sparePartsPartCategory5 => 'Electrical & Lighting System';

  @override
  String get sparePartsPartCategory6 => 'Filters & Spark Plugs';

  @override
  String get sparePartsPartCategory7 => 'Engine & Internal Parts';

  @override
  String get sparePartsPartCategory8 => 'Gearbox & Transmission';

  @override
  String get sparePartsPartCategory9 => 'Cooling & Radiator';

  @override
  String get sparePartsPartCategory10 => 'Suspension & Shock Absorbers';

  @override
  String get sparePartsPartCategory11 => 'Tires & Rims';

  @override
  String get sparePartsPartCategory12 => 'Oils & Fluids';

  @override
  String get sparePartsPartCategory13 => 'Batteries';

  @override
  String get sparePartsPartCategory14 => 'Sensors & Computer';

  @override
  String get sparePartsPartCategory15 => 'Mirrors & Glass';

  @override
  String get sparePartsPartCategory16 => 'Exhaust Systems';

  @override
  String get sparePartsPartCategory17 => 'Interior & Accessories';

  @override
  String get sparePartsPartCategory18 => 'Lamps & Lighting';

  @override
  String get sparePartsPartCategory19 => 'AC & Cooling';

  @override
  String get sparePartsPartCategory20 => 'Doors & Locks';

  @override
  String get sparePartsPartCategory21 => 'Steering & Suspension';

  @override
  String get sparePartsPartCategory22 => 'Pumps & Filters';

  @override
  String get sparePartsPartCategory23 => 'Belts & Pulleys';

  @override
  String get timePeriodAm => 'AM';

  @override
  String get timePeriodNoon => 'PM';

  @override
  String get timePeriodPm => 'PM';
}
