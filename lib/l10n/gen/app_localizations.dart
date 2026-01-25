// dart format off
// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// Text shown in the AppBar of the Counter Page
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counterAppBarTitle;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'CarCare Services'**
  String get appTitle;

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'CarCare'**
  String get appName;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Username field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Phone number field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Full name field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Search button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Don't have account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Create new account button
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccount;

  /// OTP verification page title
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// Enter verification code message
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterOtp;

  /// OTP sent message
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to'**
  String get otpSent;

  /// Resend code button
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendOtp;

  /// Resend in message
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get resendOtpIn;

  /// Verify button
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Home page
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Schedules page
  ///
  /// In en, this message translates to:
  /// **'Service Appointments'**
  String get schedules;

  /// Complaints page
  ///
  /// In en, this message translates to:
  /// **'Car Issues'**
  String get complaints;

  /// Profile page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// My schedules
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get mySchedules;

  /// Upcoming schedules
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingSchedules;

  /// Next pumping schedule
  ///
  /// In en, this message translates to:
  /// **'Next Service Appointment'**
  String get nextPumpingSchedule;

  /// Schedule details
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get scheduleDetails;

  /// View all schedules button
  ///
  /// In en, this message translates to:
  /// **'View All Appointments'**
  String get viewAllSchedules;

  /// Start time
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// End time
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// Actual start time
  ///
  /// In en, this message translates to:
  /// **'Actual Start Time'**
  String get actualStartTime;

  /// Actual end time
  ///
  /// In en, this message translates to:
  /// **'Actual End Time'**
  String get actualEndTime;

  /// Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Created by
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get createdBy;

  /// Status: Scheduled
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// Status: Active
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get active;

  /// Status: Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Status: Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Starts in
  ///
  /// In en, this message translates to:
  /// **'Starts in'**
  String get startsIn;

  /// Active now
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get activeNow;

  /// Ended ago
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get endedAgo;

  /// Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// This week
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// This month
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Date range
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// Select date range
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// My complaints
  ///
  /// In en, this message translates to:
  /// **'My Car Issues'**
  String get myComplaints;

  /// Submit complaint button
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get submitComplaint;

  /// Complaint details
  ///
  /// In en, this message translates to:
  /// **'Issue Details'**
  String get complaintDetails;

  /// Complaint title
  ///
  /// In en, this message translates to:
  /// **'Issue Title'**
  String get complaintTitle;

  /// Complaint description
  ///
  /// In en, this message translates to:
  /// **'Issue Description'**
  String get complaintDescription;

  /// Complaint category
  ///
  /// In en, this message translates to:
  /// **'Issue Category'**
  String get complaintCategory;

  /// Select category
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// Complaint category: Engine Issue
  ///
  /// In en, this message translates to:
  /// **'Engine Issue'**
  String get noWater;

  /// Complaint category: Tire Issue
  ///
  /// In en, this message translates to:
  /// **'Tire Issue'**
  String get waterQuality;

  /// Complaint category: Battery Issue
  ///
  /// In en, this message translates to:
  /// **'Battery Issue'**
  String get lowPressure;

  /// Complaint category: Service Delay
  ///
  /// In en, this message translates to:
  /// **'Service Delay'**
  String get scheduleIssue;

  /// Complaint category: Other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Complaint status: Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Complaint status: In progress
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Complaint status: Resolved
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// Complaint status: Rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Admin response
  ///
  /// In en, this message translates to:
  /// **'Service Response'**
  String get adminResponse;

  /// Handled by
  ///
  /// In en, this message translates to:
  /// **'Handled By'**
  String get handledBy;

  /// Handled at
  ///
  /// In en, this message translates to:
  /// **'Handled At'**
  String get handledAt;

  /// Created at
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// Updated at
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// Complaint submitted success message
  ///
  /// In en, this message translates to:
  /// **'Issue Reported Successfully'**
  String get complaintSubmitted;

  /// Region
  ///
  /// In en, this message translates to:
  /// **'Service Center'**
  String get region;

  /// Unit
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// Neighborhood
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get neighborhood;

  /// Zone
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get zone;

  /// Select region
  ///
  /// In en, this message translates to:
  /// **'Select Service Center'**
  String get selectRegion;

  /// Select unit
  ///
  /// In en, this message translates to:
  /// **'Select Unit'**
  String get selectUnit;

  /// Select neighborhood
  ///
  /// In en, this message translates to:
  /// **'Select Neighborhood'**
  String get selectNeighborhood;

  /// Select zone
  ///
  /// In en, this message translates to:
  /// **'Select Zone'**
  String get selectZone;

  /// Location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Select location
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// Clear selection
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get clearSelection;

  /// My profile
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Profile updated success message
  ///
  /// In en, this message translates to:
  /// **'Profile Updated Successfully'**
  String get profileUpdated;

  /// Role
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Role: Admin
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Role: Operator
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get operator;

  /// Role: Customer
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get citizen;

  /// Default location
  ///
  /// In en, this message translates to:
  /// **'Default Location'**
  String get defaultLocation;

  /// Watched location
  ///
  /// In en, this message translates to:
  /// **'Watched Location'**
  String get watchedLocation;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error occurred message
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get errorOccurred;

  /// Network error
  ///
  /// In en, this message translates to:
  /// **'Network Connection Error'**
  String get networkError;

  /// Server error
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// No internet connection
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// Try again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No data
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No schedules
  ///
  /// In en, this message translates to:
  /// **'No Appointments'**
  String get noSchedules;

  /// No complaints
  ///
  /// In en, this message translates to:
  /// **'No Reported Issues'**
  String get noComplaints;

  /// No schedules message
  ///
  /// In en, this message translates to:
  /// **'No service appointments at the moment'**
  String get noSchedulesMessage;

  /// No complaints message
  ///
  /// In en, this message translates to:
  /// **'You haven\'t reported any issues yet'**
  String get noComplaintsMessage;

  /// Pull to refresh
  ///
  /// In en, this message translates to:
  /// **'Pull to Refresh'**
  String get pullToRefresh;

  /// Release to refresh
  ///
  /// In en, this message translates to:
  /// **'Release to Refresh'**
  String get releaseToRefresh;

  /// Load more
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// Quick actions
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// View schedules
  ///
  /// In en, this message translates to:
  /// **'View Appointments'**
  String get viewSchedules;

  /// Required field message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Invalid phone number message
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// Invalid email message
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// Password too short message
  ///
  /// In en, this message translates to:
  /// **'Password too short (minimum 6 characters)'**
  String get passwordTooShort;

  /// Passwords do not match message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Maximum characters message
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} characters'**
  String maxCharacters(int max);

  /// Characters remaining message
  ///
  /// In en, this message translates to:
  /// **'{count} characters remaining'**
  String charactersRemaining(int count);

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get loginSuccess;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccess;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Change language
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Arabic language
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Contact us
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Application name in Arabic
  ///
  /// In en, this message translates to:
  /// **'CarCareX'**
  String get appNameAr;

  /// Splash screen
  ///
  /// In en, this message translates to:
  /// **'Splash Screen'**
  String get splashScreen;

  /// Profile setup
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// My vehicles
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// Add vehicle
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// Edit vehicle
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// Vehicle details
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// Maintenance history
  ///
  /// In en, this message translates to:
  /// **'Maintenance History'**
  String get maintenanceHistory;

  /// VIN number
  ///
  /// In en, this message translates to:
  /// **'VIN Number'**
  String get vinNumber;

  /// Plate number
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// Brand
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// Model
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Year
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Maintenance
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// Maintenance request
  ///
  /// In en, this message translates to:
  /// **'Maintenance Request'**
  String get maintenanceRequest;

  /// Service type
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// Oil change
  ///
  /// In en, this message translates to:
  /// **'Oil Change'**
  String get oilChange;

  /// Inspection
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get inspection;

  /// Repair
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get repair;

  /// Technician offers
  ///
  /// In en, this message translates to:
  /// **'Technician Offers'**
  String get technicianOffers;

  /// Request status
  ///
  /// In en, this message translates to:
  /// **'Request Status'**
  String get requestStatus;

  /// Rate service
  ///
  /// In en, this message translates to:
  /// **'Rate Service'**
  String get rateService;

  /// Emergency SOS
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get emergencySOS;

  /// SOS button
  ///
  /// In en, this message translates to:
  /// **'SOS Button'**
  String get sosButton;

  /// Emergency status
  ///
  /// In en, this message translates to:
  /// **'Emergency Status'**
  String get emergencyStatus;

  /// Car wash
  ///
  /// In en, this message translates to:
  /// **'Car Wash'**
  String get carWash;

  /// Book car wash
  ///
  /// In en, this message translates to:
  /// **'Book Car Wash'**
  String get bookCarWash;

  /// Wash booking status
  ///
  /// In en, this message translates to:
  /// **'Booking Status'**
  String get washBookingStatus;

  /// Center wash
  ///
  /// In en, this message translates to:
  /// **'Center Wash'**
  String get centerWash;

  /// Mobile wash
  ///
  /// In en, this message translates to:
  /// **'Mobile Wash'**
  String get mobileWash;

  /// Basic wash
  ///
  /// In en, this message translates to:
  /// **'Basic Wash'**
  String get basicWash;

  /// Premium wash
  ///
  /// In en, this message translates to:
  /// **'Premium Wash'**
  String get premiumWash;

  /// Full wash
  ///
  /// In en, this message translates to:
  /// **'Full Wash'**
  String get fullWash;

  /// Marketplace
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// Products
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// Product details
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// Cart
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Order status
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// Add to cart
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// Checkout
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Subtotal
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Total
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Rent cars
  ///
  /// In en, this message translates to:
  /// **'Rent Cars'**
  String get rentX;

  /// Available cars
  ///
  /// In en, this message translates to:
  /// **'Available Cars'**
  String get availableCars;

  /// Daily
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Rental period
  ///
  /// In en, this message translates to:
  /// **'Rental Period'**
  String get rentalPeriod;

  /// Start date
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// End date
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// Book now
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// Sell cars
  ///
  /// In en, this message translates to:
  /// **'Sell Cars'**
  String get sellX;

  /// Sell listings
  ///
  /// In en, this message translates to:
  /// **'Sell Listings'**
  String get sellListings;

  /// My listings
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// Publish listing
  ///
  /// In en, this message translates to:
  /// **'Publish Listing'**
  String get publishListing;

  /// Contact seller
  ///
  /// In en, this message translates to:
  /// **'Contact Seller'**
  String get contactSeller;

  /// Fuel delivery
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery'**
  String get fuelX;

  /// Fuel request
  ///
  /// In en, this message translates to:
  /// **'Fuel Request'**
  String get fuelRequest;

  /// Fuel type
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// Gasoline 91
  ///
  /// In en, this message translates to:
  /// **'Gasoline 91'**
  String get gasoline91;

  /// Gasoline 95
  ///
  /// In en, this message translates to:
  /// **'Gasoline 95'**
  String get gasoline95;

  /// Diesel
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// Quantity
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Liters
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// Fuel order status
  ///
  /// In en, this message translates to:
  /// **'Fuel Order Status'**
  String get fuelOrderStatus;

  /// Car owner
  ///
  /// In en, this message translates to:
  /// **'Car Owner'**
  String get carOwner;

  /// Technician
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technician;

  /// Accept
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Reject
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Proceed
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// Continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Select
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Choose
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// On the way
  ///
  /// In en, this message translates to:
  /// **'On The Way'**
  String get onTheWay;

  /// Arrived
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// Delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// Assigned
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// Requested
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// Loading data
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// No vehicles
  ///
  /// In en, this message translates to:
  /// **'No Vehicles'**
  String get noVehicles;

  /// No offers
  ///
  /// In en, this message translates to:
  /// **'No Offers'**
  String get noOffers;

  /// No listings
  ///
  /// In en, this message translates to:
  /// **'No Listings'**
  String get noListings;

  /// Success
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Current location
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// Use my current location
  ///
  /// In en, this message translates to:
  /// **'Use My Current Location'**
  String get useCurrentLocation;

  /// Enter address
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get enterAddress;

  /// City
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Pick image
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// Camera
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Profile photo
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// More
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Search products
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// Search cars
  ///
  /// In en, this message translates to:
  /// **'Search cars...'**
  String get searchCars;

  /// Sort by
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// Price: Low to High
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowHigh;

  /// Price: High to Low
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighLow;

  /// Select date
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Select time
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Time slot
  ///
  /// In en, this message translates to:
  /// **'Time Slot'**
  String get timeSlot;

  /// Now
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// Schedule
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Price
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Cost
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// Estimated price
  ///
  /// In en, this message translates to:
  /// **'Estimated Price'**
  String get estimatedPrice;

  /// Rating
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Stars
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// Leave comment
  ///
  /// In en, this message translates to:
  /// **'Leave Comment'**
  String get leaveComment;

  /// User type
  ///
  /// In en, this message translates to:
  /// **'User Type'**
  String get userType;

  /// User profile
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// Validation error
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationError;

  /// Field required
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Invalid input
  ///
  /// In en, this message translates to:
  /// **'Invalid Input'**
  String get invalidInput;

  /// Optional
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Required
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Problem details
  ///
  /// In en, this message translates to:
  /// **'Problem Details'**
  String get problemDetails;

  /// Attach photos
  ///
  /// In en, this message translates to:
  /// **'Attach Photos'**
  String get attachPhotos;

  /// Summary
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// Order summary
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// Booking summary
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
