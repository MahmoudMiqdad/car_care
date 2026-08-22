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

  /// Fuel Provider
  ///
  /// In en, this message translates to:
  /// **'Fuel Provider'**
  String get fuelProvider;

  /// No description provided for @maintenanceRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Requests'**
  String get maintenanceRequestsTitle;

  /// No description provided for @totalRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get totalRequestsLabel;

  /// No description provided for @uploadLogoLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload Logo'**
  String get uploadLogoLabel;

  /// Displays the vehicle owner name dynamically
  ///
  /// In en, this message translates to:
  /// **'Owner: {name}'**
  String vehicleOwnerWithParamLabel(String name);

  /// No description provided for @roleTechnician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get roleTechnician;

  /// No description provided for @roleCarWasher.
  ///
  /// In en, this message translates to:
  /// **'Car Wash'**
  String get roleCarWasher;

  /// No description provided for @roleFuelProvider.
  ///
  /// In en, this message translates to:
  /// **'Fuel Provider'**
  String get roleFuelProvider;

  /// No description provided for @roleShopOwner.
  ///
  /// In en, this message translates to:
  /// **'Shop Owner'**
  String get roleShopOwner;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomer;

  /// No description provided for @myServicesAsProvider.
  ///
  /// In en, this message translates to:
  /// **'My Services as Provider'**
  String get myServicesAsProvider;

  /// No description provided for @joinAsServiceProvider.
  ///
  /// In en, this message translates to:
  /// **'Join as Service Provider'**
  String get joinAsServiceProvider;

  /// No description provided for @applyAsTechnician.
  ///
  /// In en, this message translates to:
  /// **'Apply as Technician'**
  String get applyAsTechnician;

  /// No description provided for @registerCarWash.
  ///
  /// In en, this message translates to:
  /// **'Register Car Wash'**
  String get registerCarWash;

  /// No description provided for @registerAsFuelProvider.
  ///
  /// In en, this message translates to:
  /// **'Register as Fuel Provider'**
  String get registerAsFuelProvider;

  /// No description provided for @openSparePartsShop.
  ///
  /// In en, this message translates to:
  /// **'Open Spare Parts Shop'**
  String get openSparePartsShop;

  /// No description provided for @maintenanceRequests.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Requests'**
  String get maintenanceRequests;

  /// No description provided for @technicianProfile.
  ///
  /// In en, this message translates to:
  /// **'Technician Profile'**
  String get technicianProfile;

  /// No description provided for @myJobs.
  ///
  /// In en, this message translates to:
  /// **'My Jobs'**
  String get myJobs;

  /// No description provided for @availableSosRequests.
  ///
  /// In en, this message translates to:
  /// **'Available SOS Requests'**
  String get availableSosRequests;

  /// No description provided for @acceptedSosRequests.
  ///
  /// In en, this message translates to:
  /// **'Accepted SOS Requests'**
  String get acceptedSosRequests;

  /// No description provided for @myStatistics.
  ///
  /// In en, this message translates to:
  /// **'My Statistics'**
  String get myStatistics;

  /// No description provided for @myInvoices.
  ///
  /// In en, this message translates to:
  /// **'My Invoices'**
  String get myInvoices;

  /// No description provided for @carWashProfile.
  ///
  /// In en, this message translates to:
  /// **'Car Wash Profile'**
  String get carWashProfile;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// Statistics page title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @fuelProviderProfile.
  ///
  /// In en, this message translates to:
  /// **'Fuel Provider Profile'**
  String get fuelProviderProfile;

  /// No description provided for @fuelOrders.
  ///
  /// In en, this message translates to:
  /// **'Fuel Orders'**
  String get fuelOrders;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get shareLocation;

  /// No description provided for @shopProfile.
  ///
  /// In en, this message translates to:
  /// **'Shop Profile'**
  String get shopProfile;

  /// No description provided for @shopOrders.
  ///
  /// In en, this message translates to:
  /// **'Shop Orders'**
  String get shopOrders;

  /// No description provided for @shopProducts.
  ///
  /// In en, this message translates to:
  /// **'Shop Products'**
  String get shopProducts;

  /// No description provided for @shopSpecializations.
  ///
  /// In en, this message translates to:
  /// **'Shop Specializations'**
  String get shopSpecializations;

  /// No description provided for @optionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get optionsTitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitleMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Smart Car Maintenance'**
  String get onboardingTitleMaintenance;

  /// No description provided for @onboardingSubtitleMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Track your vehicle\'s service history, get timely reminders, and request maintenance with just a tap.'**
  String get onboardingSubtitleMaintenance;

  /// No description provided for @onboardingTitleEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency Roadside Help'**
  String get onboardingTitleEmergency;

  /// No description provided for @onboardingSubtitleEmergency.
  ///
  /// In en, this message translates to:
  /// **'Stuck on the road? Send an SOS and get a certified technician to your location in minutes.'**
  String get onboardingSubtitleEmergency;

  /// No description provided for @onboardingTitleAllInOne.
  ///
  /// In en, this message translates to:
  /// **'All-in-One Car Services'**
  String get onboardingTitleAllInOne;

  /// No description provided for @onboardingSubtitleAllInOne.
  ///
  /// In en, this message translates to:
  /// **'Fuel delivery, car wash, marketplace and more — everything your car needs, in one app.'**
  String get onboardingSubtitleAllInOne;

  /// No description provided for @washerSelectProvinceMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select a province'**
  String get washerSelectProvinceMessage;

  /// No description provided for @enableLocationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services'**
  String get enableLocationPrompt;

  /// No description provided for @locationErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Location error'**
  String get locationErrorPrefix;

  /// No description provided for @requestSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request sent successfully ✓'**
  String get requestSentSuccess;

  /// No description provided for @cancelSosQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is the reason for cancelling the request?'**
  String get cancelSosQuestion;

  /// No description provided for @cancelSosHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for cancelling the emergency request here...'**
  String get cancelSosHint;

  /// No description provided for @trackTechnician.
  ///
  /// In en, this message translates to:
  /// **'Track Technician'**
  String get trackTechnician;

  /// No description provided for @searchingForTechnicianTitle.
  ///
  /// In en, this message translates to:
  /// **'Searching for Technician'**
  String get searchingForTechnicianTitle;

  /// No description provided for @searchingForTechnicianSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Finding the nearest available technician for you, please wait a moment'**
  String get searchingForTechnicianSubtitle;

  /// Displays when the request was created relative to now
  ///
  /// In en, this message translates to:
  /// **'Created {time}'**
  String createdAgoLabel(String time);

  /// No description provided for @technicianOnWayLiveTracking.
  ///
  /// In en, this message translates to:
  /// **'Technician is on the way - live tracking'**
  String get technicianOnWayLiveTracking;

  /// No description provided for @waitingForLocationUpdate.
  ///
  /// In en, this message translates to:
  /// **'Waiting for location update...'**
  String get waitingForLocationUpdate;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @cartPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cartPageTitle;

  /// No description provided for @checkoutButton.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutButton;

  /// No description provided for @confirmOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrderTitle;

  /// No description provided for @orderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully'**
  String get orderCreatedSuccessfully;

  /// No description provided for @orderTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Total'**
  String get orderTotalLabel;

  /// No description provided for @currencySyp.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySyp;

  /// No description provided for @pleaseSelectDeliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select the delivery location on the map'**
  String get pleaseSelectDeliveryLocation;

  /// No description provided for @pleaseEnterAddressNote.
  ///
  /// In en, this message translates to:
  /// **'Please enter an address note'**
  String get pleaseEnterAddressNote;

  /// No description provided for @confirmOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrderButton;

  /// No description provided for @addressNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Address Note'**
  String get addressNoteLabel;

  /// No description provided for @addressNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., street name, building number, apartment, or nearby landmark'**
  String get addressNoteHint;

  /// No description provided for @deliveryLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get deliveryLocationLabel;

  /// No description provided for @selectLocationFromMapHint.
  ///
  /// In en, this message translates to:
  /// **'Select location from map'**
  String get selectLocationFromMapHint;

  /// No description provided for @locationSelectedBadge.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get locationSelectedBadge;

  /// No description provided for @changeLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocationButton;

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'CarCare'**
  String get appName;

  /// Shown when there are no SOS requests available for the technician
  ///
  /// In en, this message translates to:
  /// **'No requests available at the moment'**
  String get noAvailableRequests;

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

  /// Subtitle shown below the no-data empty state
  ///
  /// In en, this message translates to:
  /// **'Check back later or add a new request'**
  String get noDataSubtitle;

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

  /// Ready to get back on the road?
  ///
  /// In en, this message translates to:
  /// **'Ready to get back on the road?'**
  String get readySummary;

  /// Edit Password
  ///
  /// In en, this message translates to:
  /// **'Edit Password'**
  String get editPassword;

  /// Save Password
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePassword;

  /// Delete Account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Creating...
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// Enter first name
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enterFirstName;

  /// Enter email
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// Enter password
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// Password must be at least 6 characters
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Re-enter password
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get reEnterPassword;

  /// Add vehicle image
  ///
  /// In en, this message translates to:
  /// **'Add vehicle image'**
  String get addVehicleImage;

  /// Tap to select image
  ///
  /// In en, this message translates to:
  /// **'Tap to select image'**
  String get tapToSelectImage;

  /// Please select a vehicle image
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle image'**
  String get selectVehicleImage;

  /// Please fill in all fields
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFields;

  /// Vehicle added successfully
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully'**
  String get vehicleAddedSuccess;

  /// Odometer
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometer;

  /// License plate number
  ///
  /// In en, this message translates to:
  /// **'License plate number'**
  String get licensePlateNumberFull;

  /// Service records
  ///
  /// In en, this message translates to:
  /// **'Service records'**
  String get serviceRecords;

  /// Fuel records
  ///
  /// In en, this message translates to:
  /// **'Fuel records'**
  String get fuelRecords;

  /// Plate
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get plate;

  /// Current password
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// New password
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// Create Your Account
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createYourAccount;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'We’re here to keep your car in top shape. Are you ready?'**
  String get carReadyMessage;

  /// Emergency button
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// Fuel
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification;

  /// Messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// The password has been successfully changed.
  ///
  /// In en, this message translates to:
  /// **'The password has been successfully changed.'**
  String get changedpasswordsuccessfully;

  /// Enter Phone
  ///
  /// In en, this message translates to:
  /// **'Enter Phone'**
  String get enterphone;

  /// The passwords do not match.
  ///
  /// In en, this message translates to:
  /// **' The passwords do not match.'**
  String get thepasswordsdonotmatch;

  /// Active Orders
  ///
  /// In en, this message translates to:
  /// **'Active Orders '**
  String get activeorders;

  /// Save and follow
  ///
  /// In en, this message translates to:
  /// **'Save and follow'**
  String get saveandfollow;

  /// No description provided for @savevehicle.
  ///
  /// In en, this message translates to:
  /// **'Save Vehicle'**
  String get savevehicle;

  /// Spare Parts
  ///
  /// In en, this message translates to:
  /// **'Spare Parts'**
  String get parts;

  /// عرض التفاصيل
  ///
  /// In en, this message translates to:
  /// **' عرض التفاصيل'**
  String get details;

  /// Text shown while updating or loading the cars list
  ///
  /// In en, this message translates to:
  /// **'Updating car list...'**
  String get updateCarsList;

  /// Message shown when there are no cars added
  ///
  /// In en, this message translates to:
  /// **'No cars yet'**
  String get noCarsYet;

  /// Message shown after successfully updating a vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle updated successfully'**
  String get vehicleUpdatedSuccessfully;

  /// Button to save changes
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// Text shown while saving data
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Title or button for updating a vehicle
  ///
  /// In en, this message translates to:
  /// **'Update Vehicle'**
  String get updateVehicle;

  /// Button to delete a vehicle
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get deleteVehicle;

  /// Error message shown when ads cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load advertisements'**
  String get failedToLoadAds;

  /// Error message when the user enters incorrect or invalid data in a form
  ///
  /// In en, this message translates to:
  /// **'Invalid data input'**
  String get invalidInputData;

  /// No description provided for @deliveryTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Tracking'**
  String get deliveryTrackingTitle;

  /// No description provided for @selectDeliveryLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Location'**
  String get selectDeliveryLocationTitle;

  /// No description provided for @myLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get myLocationLabel;

  /// No description provided for @moveMapToPickLocation.
  ///
  /// In en, this message translates to:
  /// **'Move the map to pick the delivery location'**
  String get moveMapToPickLocation;

  /// No description provided for @confirmLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocationButton;

  /// Title for invoice details page
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetails;

  /// No description provided for @processingStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processingStatusLabel;

  /// No description provided for @outForDeliveryStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get outForDeliveryStatusLabel;

  /// No description provided for @deliveredStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveredStatusLabel;

  /// No description provided for @rejectedStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejectedStatusLabel;

  /// General title for my requests or my orders screen across different sections
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get allRequestsTitle;

  /// Label for the store or shop section
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopLabel;

  /// Text shown when there are no items inside the order or list
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProductsAvailable;

  /// Displays how many additional products are in the order
  ///
  /// In en, this message translates to:
  /// **'+{count} more items'**
  String plusMoreProductsLabel(int count);

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// Text inside add to cart button containing the total formatted price
  ///
  /// In en, this message translates to:
  /// **'Add to Cart — {price}'**
  String addToCartWithPriceLabel(String price);

  /// No description provided for @inStockStatus.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStockStatus;

  /// No description provided for @outOfStockStatus.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStockStatus;

  /// No description provided for @productConditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition: {condition}'**
  String productConditionLabel(String condition);

  /// No description provided for @productCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String productCategoryLabel(String category);

  /// No description provided for @productCarBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Car Brand: {brand}'**
  String productCarBrandLabel(String brand);

  /// No description provided for @discountPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String discountPercentLabel(String percent);

  /// No description provided for @inStockWithCountLabel.
  ///
  /// In en, this message translates to:
  /// **'In Stock ({count} items)'**
  String inStockWithCountLabel(int count);

  /// No description provided for @shopsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get shopsTitle;

  /// No description provided for @cartLabel.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartLabel;

  /// No description provided for @shopDetailsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Information'**
  String get shopDetailsPageTitle;

  /// No description provided for @businessTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessTypeLabel;

  /// No description provided for @carBrandsLabel.
  ///
  /// In en, this message translates to:
  /// **'Car Brands'**
  String get carBrandsLabel;

  /// No description provided for @partCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Part Categories'**
  String get partCategoriesLabel;

  /// No description provided for @shopStorefrontPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Storefront'**
  String get shopStorefrontPageTitle;

  /// No description provided for @sparePartsStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Spare Parts Store'**
  String get sparePartsStoreTitle;

  /// No description provided for @shareDeliveryLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Delivery Location'**
  String get shareDeliveryLocationTitle;

  /// No description provided for @startProcessingButton.
  ///
  /// In en, this message translates to:
  /// **'Start Processing'**
  String get startProcessingButton;

  /// No description provided for @startDeliveryButton.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get startDeliveryButton;

  /// No description provided for @confirmDeliveryButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirmDeliveryButton;

  /// Displays the order number with its ID
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumberLabel(String id);

  /// No description provided for @orderCancelledSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Order has been cancelled successfully'**
  String get orderCancelledSuccessMessage;

  /// No description provided for @tapToTrackFuelProviderLive.
  ///
  /// In en, this message translates to:
  /// **'Tap to track fuel provider live'**
  String get tapToTrackFuelProviderLive;

  /// No description provided for @trackFuelProviderTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Fuel Provider'**
  String get trackFuelProviderTitle;

  /// No description provided for @waitingFuelProviderAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Waiting for fuel provider acceptance'**
  String get waitingFuelProviderAcceptance;

  /// No description provided for @orderNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Notes'**
  String get orderNotesTitle;

  /// No description provided for @fuelProviderHasNotSharedLocationYet.
  ///
  /// In en, this message translates to:
  /// **'The fuel provider has not shared their location yet'**
  String get fuelProviderHasNotSharedLocationYet;

  /// No description provided for @avatarUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated successfully'**
  String get avatarUpdatedSuccess;

  /// Success message displayed when the user permanently deletes their account
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessMessage;

  /// No description provided for @fuelLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Log'**
  String get fuelLogTitle;

  /// No description provided for @costWithParamLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost: {cost}'**
  String costWithParamLabel(String cost);

  /// No description provided for @odometerReadingWithParamLabel.
  ///
  /// In en, this message translates to:
  /// **'Odometer: {km} km'**
  String odometerReadingWithParamLabel(String km);

  /// No description provided for @brandRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the vehicle brand'**
  String get brandRequiredError;

  /// No description provided for @brandMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Brand must be at least 2 characters long'**
  String get brandMinLengthError;

  /// No description provided for @brandMaxLengthError.
  ///
  /// In en, this message translates to:
  /// **'Brand is too long (maximum 50 characters)'**
  String get brandMaxLengthError;

  /// No description provided for @brandInvalidCharsError.
  ///
  /// In en, this message translates to:
  /// **'Brand contains unallowed symbols'**
  String get brandInvalidCharsError;

  /// No description provided for @modelRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the vehicle model'**
  String get modelRequiredError;

  /// No description provided for @modelMaxLengthError.
  ///
  /// In en, this message translates to:
  /// **'Model is too long (maximum 50 characters)'**
  String get modelMaxLengthError;

  /// No description provided for @modelInvalidCharsError.
  ///
  /// In en, this message translates to:
  /// **'Model contains unallowed symbols'**
  String get modelInvalidCharsError;

  /// No description provided for @plateNumberRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the plate number'**
  String get plateNumberRequiredError;

  /// No description provided for @plateInvalidCharsError.
  ///
  /// In en, this message translates to:
  /// **'Plate number contains unallowed symbols'**
  String get plateInvalidCharsError;

  /// No description provided for @plateLengthError.
  ///
  /// In en, this message translates to:
  /// **'Plate number must be between 4 and 9 characters'**
  String get plateLengthError;

  /// No description provided for @manufactureYearRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the manufacturing year'**
  String get manufactureYearRequiredError;

  /// No description provided for @invalidYearError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year'**
  String get invalidYearError;

  /// No description provided for @yearRangeError.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing year must be between 1900 and {maxYear}'**
  String yearRangeError(int maxYear);

  /// No description provided for @odometerRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the odometer reading'**
  String get odometerRequiredError;

  /// No description provided for @odometerRangeError.
  ///
  /// In en, this message translates to:
  /// **'Odometer reading must be between 0 and 2000000'**
  String get odometerRangeError;

  /// No description provided for @unsupportedImageFormatError.
  ///
  /// In en, this message translates to:
  /// **'Unsupported image format (jpg, jpeg, png or webp only)'**
  String get unsupportedImageFormatError;

  /// No description provided for @imageSizeExceededError.
  ///
  /// In en, this message translates to:
  /// **'Image size must not exceed 5 MB'**
  String get imageSizeExceededError;

  /// No description provided for @pleaseSelectVehicleImageError.
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle image'**
  String get pleaseSelectVehicleImageError;

  /// No description provided for @defaultVehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get defaultVehicleLabel;

  /// No description provided for @vehicleDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle has been deleted successfully'**
  String get vehicleDeletedSuccess;

  /// No description provided for @fuelAmountDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'{type} — {amount} Liters'**
  String fuelAmountDetailsLabel(String type, String amount);

  /// No description provided for @gasoline98.
  ///
  /// In en, this message translates to:
  /// **'Gasoline 98'**
  String get gasoline98;

  /// No description provided for @completeAllFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields'**
  String get completeAllFieldsError;

  /// No description provided for @fuelOrderSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Fuel order sent successfully'**
  String get fuelOrderSentSuccessfully;

  /// No description provided for @editButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButtonLabel;

  /// No description provided for @ownerStockCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock: {count}'**
  String ownerStockCountLabel(int count);

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @productNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productNameRequired;

  /// No description provided for @enterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get enterValidPrice;

  /// No description provided for @availableQuantity.
  ///
  /// In en, this message translates to:
  /// **'Available Quantity'**
  String get availableQuantity;

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @classification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get classification;

  /// No description provided for @productCondition.
  ///
  /// In en, this message translates to:
  /// **'Product Condition'**
  String get productCondition;

  /// No description provided for @carBrand.
  ///
  /// In en, this message translates to:
  /// **'Car Brand'**
  String get carBrand;

  /// No description provided for @partCategory.
  ///
  /// In en, this message translates to:
  /// **'Part Category'**
  String get partCategory;

  /// No description provided for @noSelection.
  ///
  /// In en, this message translates to:
  /// **'No selection'**
  String get noSelection;

  /// No description provided for @productImages.
  ///
  /// In en, this message translates to:
  /// **'Product Images'**
  String get productImages;

  /// No description provided for @addImages.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get addImages;

  /// No description provided for @imagesCount.
  ///
  /// In en, this message translates to:
  /// **'Images ({count}/{max})'**
  String imagesCount(int count, int max);

  /// No description provided for @confirmSelectionButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selection'**
  String get confirmSelectionButtonLabel;

  /// No description provided for @shopProfilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Profile'**
  String get shopProfilePageTitle;

  /// No description provided for @fillAllFieldsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillAllFieldsRequiredError;

  /// No description provided for @shopSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Store saved successfully'**
  String get shopSavedSuccess;

  /// No description provided for @shopNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get shopNameLabel;

  /// No description provided for @shopNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter store name'**
  String get shopNameHint;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneNumberHint;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city name'**
  String get cityHint;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unknownStatus;

  /// No description provided for @unknownProfileValuesError.
  ///
  /// In en, this message translates to:
  /// **'Unknown values in your profile: {values}\nCannot save until these values are matched in the system.'**
  String unknownProfileValuesError(String values);

  /// Button text to save and update the store profile information
  ///
  /// In en, this message translates to:
  /// **'Update Store'**
  String get updateProduct;

  /// No description provided for @chooseActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get chooseActionLabel;

  /// No description provided for @noSelectionMadeYet.
  ///
  /// In en, this message translates to:
  /// **'No selection made yet'**
  String get noSelectionMadeYet;

  /// No description provided for @confirmMultiSelectionCount.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selection ({count})'**
  String confirmMultiSelectionCount(int count);

  /// No description provided for @shopSpecializationsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Specializations'**
  String get shopSpecializationsPageTitle;

  /// No description provided for @specializationsUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Specializations updated successfully'**
  String get specializationsUpdatedSuccess;

  /// No description provided for @inactiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveStatus;

  /// No description provided for @myJobsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Jobs'**
  String get myJobsTitle;

  /// No description provided for @jobAssignedStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get jobAssignedStatusLabel;

  /// No description provided for @jobStatusUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task status updated successfully'**
  String get jobStatusUpdatedSuccess;

  /// No description provided for @jobLoadErrorLabel.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading jobs'**
  String get jobLoadErrorLabel;

  /// No description provided for @refreshOrdersLogHint.
  ///
  /// In en, this message translates to:
  /// **'Updating requests log ...'**
  String get refreshOrdersLogHint;

  /// No description provided for @clientLabel.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get clientLabel;

  /// No description provided for @appointmentNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Appointment Notes'**
  String get appointmentNotesLabel;

  /// No description provided for @startWorkButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Work'**
  String get startWorkButtonLabel;

  /// No description provided for @endWorkButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'End Work'**
  String get endWorkButtonLabel;

  /// No description provided for @completeJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Task'**
  String get completeJobTitle;

  /// No description provided for @completionNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Completion Notes'**
  String get completionNotesLabel;

  /// No description provided for @completionNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Type what has been accomplished...'**
  String get completionNotesHint;

  /// No description provided for @completionNotesRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Completion notes are required'**
  String get completionNotesRequiredError;

  /// No description provided for @confirmCompletionButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Completion'**
  String get confirmCompletionButton;

  /// No description provided for @updatingProgress.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updatingProgress;

  /// No description provided for @quotationPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price Offer'**
  String get quotationPriceLabel;

  /// No description provided for @quotationSentWaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Your offer has been sent — waiting for customer approval'**
  String get quotationSentWaitingApproval;

  /// No description provided for @submitQuotationButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit Price Offer'**
  String get submitQuotationButtonLabel;

  /// No description provided for @quotationSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Offer submitted successfully'**
  String get quotationSubmittedSuccess;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @customerDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerDataTitle;

  /// No description provided for @malfunctionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Malfunction Details'**
  String get malfunctionDetailsTitle;

  /// No description provided for @requestDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Date'**
  String get requestDateLabel;

  /// Label for the current status of an order or request
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @vehicleDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleDataTitle;

  /// Button text or screen title to add or register a new technician
  ///
  /// In en, this message translates to:
  /// **'Add Technician'**
  String get addTechnicianLabel;

  /// Screen title or button text to edit the technician profile information
  ///
  /// In en, this message translates to:
  /// **'Edit Technician Profile'**
  String get editTechnicianProfileLabel;

  /// No description provided for @technicianJoinRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Technician join request submitted successfully'**
  String get technicianJoinRequestSuccess;

  /// No description provided for @certificationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certificationsSectionTitle;

  /// No description provided for @maxThreeImagesHint.
  ///
  /// In en, this message translates to:
  /// **'Maximum 3 images'**
  String get maxThreeImagesHint;

  /// No description provided for @workshopLocationSet.
  ///
  /// In en, this message translates to:
  /// **'Workshop location set'**
  String get workshopLocationSet;

  /// No description provided for @selectWorkshopLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Workshop Location'**
  String get selectWorkshopLocation;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get myLocation;

  /// No description provided for @moveMapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Move the map to set the correct location'**
  String get moveMapToSelectLocation;

  /// No description provided for @savingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingInProgress;

  /// No description provided for @confirmLocationAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocationAction;

  /// No description provided for @currencySuffix.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySuffix;

  /// No description provided for @availableQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Quantity'**
  String get availableQuantityLabel;

  /// No description provided for @saveChangesButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesButtonLabel;

  /// No description provided for @availabilityStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Availability Status'**
  String get availabilityStatusLabel;

  /// No description provided for @availableForWork.
  ///
  /// In en, this message translates to:
  /// **'Available for Work'**
  String get availableForWork;

  /// No description provided for @unavailableForWork.
  ///
  /// In en, this message translates to:
  /// **'Unavailable for Work'**
  String get unavailableForWork;

  /// Error message when picking more images than the maximum allowed limit
  ///
  /// In en, this message translates to:
  /// **'You can select a maximum of {count} images'**
  String maxImagesLimitError(int count);

  /// No description provided for @personalDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalDataTitle;

  /// No description provided for @professionalDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalDataTitle;

  /// No description provided for @hourlyRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRateLabel;

  /// No description provided for @mechanicLabel.
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get mechanicLabel;

  /// No description provided for @electricityLabel.
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get electricityLabel;

  /// No description provided for @paintLabel.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get paintLabel;

  /// No description provided for @tiresLabel.
  ///
  /// In en, this message translates to:
  /// **'Tires'**
  String get tiresLabel;

  /// No description provided for @airConditioningLabel.
  ///
  /// In en, this message translates to:
  /// **'Air Conditioning'**
  String get airConditioningLabel;

  /// No description provided for @plumbingLabel.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get plumbingLabel;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the profile'**
  String get profileLoadError;

  /// No description provided for @updateWorkshopLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'You can update the workshop location when needed'**
  String get updateWorkshopLocationDescription;

  /// No description provided for @addNewCertificationsHint.
  ///
  /// In en, this message translates to:
  /// **'You can add new certifications'**
  String get addNewCertificationsHint;

  /// No description provided for @professionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInfo;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @experienceYears.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get experienceYears;

  /// No description provided for @hourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRate;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfo;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @durationRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the expected duration'**
  String get durationRequiredError;

  /// No description provided for @invalidNumberError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalidNumberError;

  /// No description provided for @durationRangeError.
  ///
  /// In en, this message translates to:
  /// **'Duration must be between 1 and 30 days'**
  String get durationRangeError;

  /// No description provided for @enterExpectedPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter the expected price...'**
  String get enterExpectedPriceHint;

  /// No description provided for @durationInDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (in Days)'**
  String get durationInDaysLabel;

  /// No description provided for @durationRangeHint.
  ///
  /// In en, this message translates to:
  /// **'From 1 to 30 days'**
  String get durationRangeHint;

  /// No description provided for @requiredPartsLabel.
  ///
  /// In en, this message translates to:
  /// **'Required Parts'**
  String get requiredPartsLabel;

  /// No description provided for @includedInPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Included in Price'**
  String get includedInPriceLabel;

  /// No description provided for @additionalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Price'**
  String get additionalPriceLabel;

  /// No description provided for @netEarningsLabel.
  ///
  /// In en, this message translates to:
  /// **'Net Earnings'**
  String get netEarningsLabel;

  /// No description provided for @statusDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Details'**
  String get statusDetailsTitle;

  /// No description provided for @assignedStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assignedStatusLabel;

  /// No description provided for @cancellationReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason is required'**
  String get cancellationReasonRequired;

  /// No description provided for @cancellationReasonMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'The cancellation reason must be at least 5 characters long'**
  String cancellationReasonMinLengthError(int count);

  /// No description provided for @sosGenericActionError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while performing the action, please try again'**
  String get sosGenericActionError;

  /// No description provided for @sosStatusUpdatedWithLabel.
  ///
  /// In en, this message translates to:
  /// **'Status updated: {status}'**
  String sosStatusUpdatedWithLabel(String status);

  /// No description provided for @startHeadingButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Heading'**
  String get startHeadingButtonLabel;

  /// No description provided for @acceptRequestToNavigateHint.
  ///
  /// In en, this message translates to:
  /// **'Accept the request to start heading to the customer'**
  String get acceptRequestToNavigateHint;

  /// No description provided for @headingToClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Heading to Customer'**
  String get headingToClientTitle;

  /// No description provided for @cancelResponseTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Response'**
  String get cancelResponseTitle;

  /// No description provided for @cancelResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancelling response'**
  String get cancelResponseLabel;

  /// No description provided for @cancelResponseHint.
  ///
  /// In en, this message translates to:
  /// **'Type the reason for cancelling response...'**
  String get cancelResponseHint;

  /// No description provided for @trackOrderWithIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracking Order #{id}'**
  String trackOrderWithIdLabel(String id);

  /// No description provided for @confirmExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Exit'**
  String get confirmExitTitle;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @stopSharingLocationWarning.
  ///
  /// In en, this message translates to:
  /// **'Your location sharing will stop. Do you want to exit?'**
  String get stopSharingLocationWarning;

  /// No description provided for @exitActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitActionLabel;

  /// No description provided for @jobCompletedSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Order completed successfully ✓'**
  String get jobCompletedSuccessMessage;

  /// No description provided for @writeAdditionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Write any additional notes...'**
  String get writeAdditionalNotesHint;

  /// No description provided for @sendQuotationActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Send Offer'**
  String get sendQuotationActionLabel;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully ✓'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @noCertificatesUploaded.
  ///
  /// In en, this message translates to:
  /// **'No certificates uploaded yet'**
  String get noCertificatesUploaded;

  /// No description provided for @workshopLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Workshop Location'**
  String get workshopLocationTitle;

  /// No description provided for @workshopLocationDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Select your workshop location to appear to nearby customers'**
  String get workshopLocationDescriptionHint;

  /// No description provided for @vehicleLabelWithParam.
  ///
  /// In en, this message translates to:
  /// **'{brand} {model}'**
  String vehicleLabelWithParam(Object brand, Object model);

  /// No description provided for @productAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get productAddedSuccessfully;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @ownerProductsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Products'**
  String get ownerProductsPageTitle;

  /// No description provided for @sosRequestCreatedAgo.
  ///
  /// In en, this message translates to:
  /// **'Created {time} ago'**
  String sosRequestCreatedAgo(String time);

  /// No description provided for @sosAcceptingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Accepting...'**
  String get sosAcceptingInProgress;

  /// No description provided for @sosAcceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get sosAcceptRequest;

  /// No description provided for @sosProcessingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get sosProcessingInProgress;

  /// No description provided for @sosStartProgress.
  ///
  /// In en, this message translates to:
  /// **'Start Progress'**
  String get sosStartProgress;

  /// No description provided for @sosFinishRequest.
  ///
  /// In en, this message translates to:
  /// **'Finish Request'**
  String get sosFinishRequest;

  /// No description provided for @sosCancelResponse.
  ///
  /// In en, this message translates to:
  /// **'Cancel Response'**
  String get sosCancelResponse;

  /// No description provided for @sosChangeStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Request Status'**
  String get sosChangeStatusTitle;

  /// No description provided for @sosInProgressStatus.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get sosInProgressStatus;

  /// No description provided for @sosCompletedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sosCompletedStatus;

  /// No description provided for @sosNavigateToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Customer'**
  String get sosNavigateToCustomer;

  /// No description provided for @sosUpdatingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get sosUpdatingInProgress;

  /// No description provided for @shopOrdersPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Orders'**
  String get shopOrdersPageTitle;

  /// No description provided for @statusUpdatedSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Request status updated successfully'**
  String get statusUpdatedSuccessMessage;

  /// No description provided for @statusUpdatedWithDynamicLabel.
  ///
  /// In en, this message translates to:
  /// **'Status updated: {status}'**
  String statusUpdatedWithDynamicLabel(String status);

  /// No description provided for @sosStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Request status updated'**
  String get sosStatusUpdated;

  /// No description provided for @sosCustomerLocation.
  ///
  /// In en, this message translates to:
  /// **'Customer Location'**
  String get sosCustomerLocation;

  /// No description provided for @sosStartNavigateToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Start navigating to customer'**
  String get sosStartNavigateToCustomer;

  /// No description provided for @sosAcceptToNavigateHint.
  ///
  /// In en, this message translates to:
  /// **'Accept the request to start navigating to the customer'**
  String get sosAcceptToNavigateHint;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @sosLocationSendError.
  ///
  /// In en, this message translates to:
  /// **'Error sending location: {message}'**
  String sosLocationSendError(String message);

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @youLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youLabel;

  /// No description provided for @distanceInMeters.
  ///
  /// In en, this message translates to:
  /// **'{value} m'**
  String distanceInMeters(String value);

  /// No description provided for @distanceInKm.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String distanceInKm(String value);

  /// No description provided for @sharingLocationActive.
  ///
  /// In en, this message translates to:
  /// **'Sharing your location with the customer'**
  String get sharingLocationActive;

  /// No description provided for @locatingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get locatingInProgress;

  /// No description provided for @calculatingRouteInProgress.
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get calculatingRouteInProgress;

  /// No description provided for @distanceToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Distance to customer'**
  String distanceToCustomer(String distance);

  /// No description provided for @conditionNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get conditionNew;

  /// No description provided for @conditionUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get conditionUsed;

  /// Label or description for the product image asset
  ///
  /// In en, this message translates to:
  /// **'Product Image'**
  String get productImageLabel;

  /// No description provided for @allProductsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get allProductsPageTitle;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailsTitle;

  /// No description provided for @productAddedToCartSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart successfully'**
  String get productAddedToCartSuccess;

  /// No description provided for @viewCartButton.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCartButton;

  /// No description provided for @cancelOrderFormHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., I no longer need this order'**
  String get cancelOrderFormHint;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsTitle;

  /// No description provided for @orderNumberLabel1.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumberLabel1;

  /// No description provided for @cancellableLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellable'**
  String get cancellableLabel;

  /// No description provided for @rejectOrderFormHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Product is currently out of stock'**
  String get rejectOrderFormHint;

  /// No description provided for @confirmRejectionButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Rejection'**
  String get confirmRejectionButton;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @arabicLabel.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLabel;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @lightModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightModeLabel;

  /// No description provided for @darkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkModeLabel;

  /// No description provided for @systemModeLabel.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemModeLabel;

  /// No description provided for @productsLabel.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsLabel;

  /// No description provided for @deliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryLabel;

  /// No description provided for @grandTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotalLabel;

  /// No description provided for @trackDeliveryButton.
  ///
  /// In en, this message translates to:
  /// **'Track Delivery'**
  String get trackDeliveryButton;

  /// No description provided for @cancelOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderButton;

  /// Label for invoice number
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumber;

  /// Label for invoice period
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get invoicePeriod;

  /// Label for invoice total amount
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get invoiceTotal;

  /// Label for invoice subtotal
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get invoiceSubtotal;

  /// Label for invoice commission total
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get invoiceCommission;

  /// Label for invoice subscription total
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get invoiceSubscription;

  /// Label for invoice status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get invoiceStatus;

  /// Label for invoice paid date
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get invoicePaidAt;

  /// Title for invoice items list
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get invoiceItems;

  /// Invoice status: draft
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// Invoice status: issued
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get statusIssued;

  /// Invoice status: overdue
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// Invoice status: paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// Title of delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeleteTitle;

  /// Warning message before deleting a vehicle
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle?\nThis action cannot be undone.'**
  String get confirmDeleteMessage;

  /// Owner label in vehicle details page
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// Unit for kilometers
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// Title of maintenance record
  ///
  /// In en, this message translates to:
  /// **'Maintenance Record'**
  String get maintenanceRecord;

  /// Title of fuel record
  ///
  /// In en, this message translates to:
  /// **'Fuel Record'**
  String get fuelRecord;

  /// Title of alerts record
  ///
  /// In en, this message translates to:
  /// **'Alerts Record'**
  String get alertsRecord;

  /// Total jobs count
  ///
  /// In en, this message translates to:
  /// **'Total jobs'**
  String get totalJobs;

  /// Assigned jobs count
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assignedJobs;

  /// In progress jobs count
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgressJobs;

  /// Completed jobs count
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedJobs;

  /// Total quotations count
  ///
  /// In en, this message translates to:
  /// **'Total quotations'**
  String get totalQuotations;

  /// Pending quotations count
  ///
  /// In en, this message translates to:
  /// **'Pending quotations'**
  String get pendingQuotations;

  /// Accepted quotations count
  ///
  /// In en, this message translates to:
  /// **'Accepted quotations'**
  String get acceptedQuotations;

  /// Total ratings count
  ///
  /// In en, this message translates to:
  /// **'Total ratings'**
  String get totalRatings;

  /// Title of delete profile dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// Delete confirmation button
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeleteProfileTitle;

  /// Warning message before deleting profile
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?\nThis action cannot be undone.'**
  String get confirmDeleteProfileMessage;

  /// Message shown after successful deletion
  ///
  /// In en, this message translates to:
  /// **'Profile deleted successfully'**
  String get profileDeletedSuccessfully;

  /// Message shown when the phone field is left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get enterPhone;

  /// Message shown when the phone number is incorrect or incomplete
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// Action to open the technician profile flow from the More tab
  ///
  /// In en, this message translates to:
  /// **'Enter as technician'**
  String get enterAsTechnician;

  /// App bar title for the car wash directory list
  ///
  /// In en, this message translates to:
  /// **'Car washes'**
  String get washersPageTitle;

  /// Car wash list filter: choose by city
  ///
  /// In en, this message translates to:
  /// **'By city'**
  String get washersByCity;

  /// Button to book a car wash appointment
  ///
  /// In en, this message translates to:
  /// **'Book an appointment'**
  String get washersBookAppointment;

  /// Button to open car wash details
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get washersViewDetails;

  /// Line showing the city of a car wash
  ///
  /// In en, this message translates to:
  /// **'City: {cityName}'**
  String washersCityWithName(String cityName);

  /// Line showing how many ratings a car wash has
  ///
  /// In en, this message translates to:
  /// **'Ratings: {count}'**
  String washersRatingsWithCount(int count);

  /// Service tier label: basic
  ///
  /// In en, this message translates to:
  /// **'BASIC'**
  String get washerTierBasic;

  /// Service tier label: VIP
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get washerTierVip;

  /// Service tier label: premium
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get washerTierPremium;

  /// App bar: washer details screen
  ///
  /// In en, this message translates to:
  /// **'Car wash details'**
  String get washerDetailsTitle;

  /// Opening time label for a car wash
  ///
  /// In en, this message translates to:
  /// **'Open: {time}'**
  String washerOpenTime(String time);

  /// Closing time label for a car wash
  ///
  /// In en, this message translates to:
  /// **'Close: {time}'**
  String washerCloseTime(String time);

  /// Header for location block
  ///
  /// In en, this message translates to:
  /// **'City and address'**
  String get washerSectionCityAndAddress;

  /// Header for packages section
  ///
  /// In en, this message translates to:
  /// **'Services and prices'**
  String get washerSectionServicesAndPrices;

  /// Header for reviews
  ///
  /// In en, this message translates to:
  /// **'Customer reviews'**
  String get washerSectionCustomerReviews;

  /// Car wash service: exterior
  ///
  /// In en, this message translates to:
  /// **'Exterior'**
  String get washerServiceExterior;

  /// Car wash service: interior
  ///
  /// In en, this message translates to:
  /// **'Interior'**
  String get washerServiceInterior;

  /// Car wash service: engine bay
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get washerServiceEngine;

  /// Package price in USD
  ///
  /// In en, this message translates to:
  /// **'price: {amount} \$'**
  String washerPackagePrice(int amount);

  /// App bar: car wash booking screen
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get washerReservationTitle;

  /// No description provided for @washerReservationFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get washerReservationFieldDate;

  /// No description provided for @washerReservationFieldTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get washerReservationFieldTime;

  /// No description provided for @washerReservationFieldVehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your vehicle type'**
  String get washerReservationFieldVehicleLabel;

  /// No description provided for @washerReservationFieldVehicleHint.
  ///
  /// In en, this message translates to:
  /// **'Type your vehicle here'**
  String get washerReservationFieldVehicleHint;

  /// No description provided for @washerReservationFieldNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get washerReservationFieldNotesLabel;

  /// No description provided for @washerReservationFieldNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any notes you want'**
  String get washerReservationFieldNotesHint;

  /// No description provided for @washerReservationChooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose the right service'**
  String get washerReservationChooseService;

  /// No description provided for @washerReservationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm reservation'**
  String get washerReservationConfirm;

  /// No description provided for @washerReservationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel reservation'**
  String get washerReservationCancel;

  /// No description provided for @washerReservationPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get washerReservationPickDate;

  /// No description provided for @washerReservationPickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get washerReservationPickTime;

  /// No description provided for @washerReservationServicePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get washerReservationServicePremium;

  /// No description provided for @washerReservationServiceVip.
  ///
  /// In en, this message translates to:
  /// **'Vip'**
  String get washerReservationServiceVip;

  /// No description provided for @washerReservationServiceBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get washerReservationServiceBasic;

  /// App bar title for bookings page
  ///
  /// In en, this message translates to:
  /// **'My Reserved'**
  String get bookingsPageTitle;

  /// Bookings filter label
  ///
  /// In en, this message translates to:
  /// **'By status'**
  String get bookingsFilterByStatus;

  /// Message shown when a user tries to book but has no vehicles registered
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any vehicles. Please add a vehicle first from the My Vehicles page.'**
  String get washerNoVehiclesMessage;

  /// Validation message when a user forgets to select a vehicle before booking
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle'**
  String get washerSelectVehicleMessage;

  /// Validation message when a user forgets to select date or time
  ///
  /// In en, this message translates to:
  /// **'Please select a date and time'**
  String get washerSelectDateTimeMessage;

  /// Success message displayed after a successful booking completion
  ///
  /// In en, this message translates to:
  /// **'Booking completed successfully'**
  String get washerBookingSuccessMessage;

  /// Text shown while the system is fetching the user's vehicles
  ///
  /// In en, this message translates to:
  /// **'Loading your vehicles...'**
  String get loadingYourVehicles;

  /// Text shown when the user has not added any vehicles to their profile
  ///
  /// In en, this message translates to:
  /// **'No vehicles added'**
  String get noVehiclesAdded;

  /// Label or title guiding the user to select one of their vehicles
  ///
  /// In en, this message translates to:
  /// **'Select your vehicle'**
  String get selectYourVehicle;

  /// No description provided for @bookingStatusesTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Statuses'**
  String get bookingStatusesTitle;

  /// No description provided for @pleaseEnterCancellationReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter the reason for cancellation'**
  String get pleaseEnterCancellationReason;

  /// No description provided for @orderAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order accepted successfully'**
  String get orderAcceptedSuccess;

  /// No description provided for @orderStartedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order execution started successfully'**
  String get orderStartedSuccess;

  /// No description provided for @orderCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order completed successfully'**
  String get orderCompletedSuccess;

  /// No description provided for @orderCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully'**
  String get orderCancelledSuccess;

  /// No description provided for @cancelFuelOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Fuel Order'**
  String get cancelFuelOrderTitle;

  /// No description provided for @ratingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratingsTitle;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUserName;

  /// Label displaying the total number of ratings
  ///
  /// In en, this message translates to:
  /// **'({count} reviews)'**
  String ratingsCountLabel(int count);

  /// Format for displaying currency in English
  ///
  /// In en, this message translates to:
  /// **'\${amount}'**
  String currencyFormat(String amount);

  /// No description provided for @shareLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get shareLocationTitle;

  /// No description provided for @shareLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'Select an in-progress fuel order from my orders to share your location'**
  String get shareLocationDescription;

  /// No description provided for @goToMyOrders.
  ///
  /// In en, this message translates to:
  /// **'Go to My Orders'**
  String get goToMyOrders;

  /// Title for the section displaying different order status indicators
  ///
  /// In en, this message translates to:
  /// **'Order Statuses'**
  String get orderStatusesTitle;

  /// No description provided for @homeWelcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'- How can we help you today? -'**
  String get homeWelcomeGreeting;

  /// No description provided for @quotationDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Offer Details'**
  String get quotationDetailsTitle;

  /// No description provided for @quotationAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Offer accepted successfully'**
  String get quotationAcceptedSuccess;

  /// No description provided for @quotationRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Offer rejected'**
  String get quotationRejectedSuccess;

  /// No description provided for @quotationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Quotations'**
  String get quotationsTitle;

  /// No description provided for @noQuotationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No price quotations available'**
  String get noQuotationsAvailable;

  /// No description provided for @acceptQuotationTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept Quotation'**
  String get acceptQuotationTitle;

  /// No description provided for @selectedDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Date'**
  String get selectedDateLabel;

  /// No description provided for @chooseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get chooseDateLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @confirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @technicianLabel.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technicianLabel;

  /// No description provided for @repairDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Repair Duration'**
  String get repairDurationLabel;

  /// No description provided for @partsIncludedLabel.
  ///
  /// In en, this message translates to:
  /// **'Parts Included'**
  String get partsIncludedLabel;

  /// Displays the estimated repair duration in days
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String durationInDays(int count);

  /// No description provided for @cannotShareLocationOrderFinished.
  ///
  /// In en, this message translates to:
  /// **'Cannot share location for a finished or cancelled order'**
  String get cannotShareLocationOrderFinished;

  /// No description provided for @enableLocationServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services in device settings'**
  String get enableLocationServiceMessage;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied, please enable it from app settings'**
  String get locationPermissionDeniedForever;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to share your location with the customer'**
  String get locationPermissionRequired;

  /// No description provided for @unableToDetermineLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to determine your current location, please try again'**
  String get unableToDetermineLocation;

  /// No description provided for @genericErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again'**
  String get genericErrorTryAgain;

  /// No description provided for @errorSendingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error sending location'**
  String get errorSendingLocation;

  /// No description provided for @deliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get deliveryLocation;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @sharingLocationWithCustomer.
  ///
  /// In en, this message translates to:
  /// **'Sharing your location with the customer'**
  String get sharingLocationWithCustomer;

  /// No description provided for @determiningLocation.
  ///
  /// In en, this message translates to:
  /// **'Determining location...'**
  String get determiningLocation;

  /// No description provided for @calculatingRoute.
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get calculatingRoute;

  /// No description provided for @meterUnit.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get meterUnit;

  /// No description provided for @kmUnit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmUnit;

  /// No description provided for @technicianInfoCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Technician Information'**
  String get technicianInfoCardTitle;

  /// No description provided for @specializationLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specializationLabel;

  /// No description provided for @experienceYearsLabel.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get experienceYearsLabel;

  /// No description provided for @quotationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Quotation Date'**
  String get quotationDateLabel;

  /// No description provided for @technicianNotesCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Technician Notes'**
  String get technicianNotesCardTitle;

  /// No description provided for @acceptQuotationButton.
  ///
  /// In en, this message translates to:
  /// **'Accept Offer'**
  String get acceptQuotationButton;

  /// No description provided for @rejectQuotationButton.
  ///
  /// In en, this message translates to:
  /// **'Reject Offer'**
  String get rejectQuotationButton;

  /// No description provided for @rejectQuotationReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Reason for Rejection'**
  String get rejectQuotationReasonTitle;

  /// Displays experience duration in years
  ///
  /// In en, this message translates to:
  /// **'{count} Years'**
  String durationInYears(int count);

  /// No description provided for @maintenanceRequestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Request Details'**
  String get maintenanceRequestDetailsTitle;

  /// No description provided for @unexpectedErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during execution, please try again'**
  String get unexpectedErrorTryAgain;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @selectPreferredDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Preferred Date'**
  String get selectPreferredDateTitle;

  /// No description provided for @selectPriorityTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Priority'**
  String get selectPriorityTitle;

  /// No description provided for @problemDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Problem Description'**
  String get problemDescriptionTitle;

  /// No description provided for @problemDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Please type the details of the problem here...'**
  String get problemDescriptionHint;

  /// No description provided for @noVehicleSelectedPrompt.
  ///
  /// In en, this message translates to:
  /// **'No vehicle selected'**
  String get noVehicleSelectedPrompt;

  /// No description provided for @changeVehicleButton.
  ///
  /// In en, this message translates to:
  /// **'Change Vehicle'**
  String get changeVehicleButton;

  /// Displays the vehicle mileage in kilometers
  ///
  /// In en, this message translates to:
  /// **'{count} km'**
  String kilometerCountLabel(int count);

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @vehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleLabel;

  /// No description provided for @appointmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointmentLabel;

  /// No description provided for @confirmCancellationButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellationButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// Label for the cancellation reason field
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellationReason;

  /// Hint text inside the cancellation reason text field
  ///
  /// In en, this message translates to:
  /// **'Type cancellation reason...'**
  String get bookingsCancelReasonHint;

  /// Text for the cancellation button or title in the dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequestButton;

  /// No description provided for @deleteRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Request'**
  String get deleteRequestTitle;

  /// No description provided for @deleteRequestConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this request?'**
  String get deleteRequestConfirmation;

  /// No description provided for @cannotUndoActionWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get cannotUndoActionWarning;

  /// No description provided for @yesDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yesDeleteButton;

  /// No description provided for @requestDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request deleted successfully'**
  String get requestDeletedSuccess;

  /// No description provided for @cancellingProgress.
  ///
  /// In en, this message translates to:
  /// **'Cancelling...'**
  String get cancellingProgress;

  /// No description provided for @deletingProgress.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deletingProgress;

  /// Displays the quotations button text with its length
  ///
  /// In en, this message translates to:
  /// **'Offers ({count})'**
  String quotationsCountLabel(int count);

  /// No description provided for @requestImagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Images'**
  String get requestImagesTitle;

  /// No description provided for @requestInfoCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Data'**
  String get requestInfoCardTitle;

  /// No description provided for @preferredDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date'**
  String get preferredDateLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @creationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Creation Date'**
  String get creationDateLabel;

  /// No description provided for @technicianLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Technician Location'**
  String get technicianLocationTitle;

  /// No description provided for @plateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumberLabel;

  /// No description provided for @mileageLabel.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileageLabel;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @noVehiclesAddOneFirst.
  ///
  /// In en, this message translates to:
  /// **'You have no vehicles, please add one first from My Vehicles'**
  String get noVehiclesAddOneFirst;

  /// No description provided for @maxThreeImagesAllowed.
  ///
  /// In en, this message translates to:
  /// **'You can select up to 3 images'**
  String get maxThreeImagesAllowed;

  /// No description provided for @pleaseSelectVehicleFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle first'**
  String get pleaseSelectVehicleFirst;

  /// No description provided for @pleaseDescribeProblem.
  ///
  /// In en, this message translates to:
  /// **'Please describe the problem'**
  String get pleaseDescribeProblem;

  /// No description provided for @internalError.
  ///
  /// In en, this message translates to:
  /// **'Internal error'**
  String get internalError;

  /// No description provided for @requestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request sent successfully'**
  String get requestSentSuccessfully;

  /// No description provided for @maintenanceRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Request'**
  String get maintenanceRequestTitle;

  /// Displays the fuel type along with its amount in liters
  ///
  /// In en, this message translates to:
  /// **'{type} - {amount} Liters'**
  String fuelAmountLabel(String type, num amount);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Validation or hint text asking the user to provide a reason for rejecting a request
  ///
  /// In en, this message translates to:
  /// **'Please enter the reason for rejection'**
  String get pleaseEnterRejectionReason;

  /// No description provided for @otherServices.
  ///
  /// In en, this message translates to:
  /// **'Other Services'**
  String get otherServices;

  /// No description provided for @washerAvailabilityUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Availability status updated successfully'**
  String get washerAvailabilityUpdateSuccess;

  /// No description provided for @washerAvailabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Available for bookings'**
  String get washerAvailabilityTitle;

  /// No description provided for @washerAvailabilityStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Currently available'**
  String get washerAvailabilityStatusAvailable;

  /// No description provided for @washerAvailabilityStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Currently unavailable'**
  String get washerAvailabilityStatusUnavailable;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @profileWasherDefaultServices.
  ///
  /// In en, this message translates to:
  /// **'Normal Wash, Premium Wash, Polishing'**
  String get profileWasherDefaultServices;

  /// No description provided for @pleaseEnterShopName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the car wash name'**
  String get pleaseEnterShopName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter the phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter the city'**
  String get pleaseEnterCity;

  /// No description provided for @profileWasherCreateSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Car wash profile created successfully'**
  String get profileWasherCreateSuccessMessage;

  /// No description provided for @profileWasherEditSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get profileWasherEditSuccessMessage;

  /// No description provided for @allGovernorates.
  ///
  /// In en, this message translates to:
  /// **'All Governorates'**
  String get allGovernorates;

  /// No description provided for @filterByGovernorate.
  ///
  /// In en, this message translates to:
  /// **'By Governorate'**
  String get filterByGovernorate;

  /// No description provided for @damascus.
  ///
  /// In en, this message translates to:
  /// **'Damascus'**
  String get damascus;

  /// No description provided for @rifDimashq.
  ///
  /// In en, this message translates to:
  /// **'Rif Dimashq'**
  String get rifDimashq;

  /// No description provided for @aleppo.
  ///
  /// In en, this message translates to:
  /// **'Aleppo'**
  String get aleppo;

  /// No description provided for @homs.
  ///
  /// In en, this message translates to:
  /// **'Homs'**
  String get homs;

  /// No description provided for @hama.
  ///
  /// In en, this message translates to:
  /// **'Hama'**
  String get hama;

  /// No description provided for @latakia.
  ///
  /// In en, this message translates to:
  /// **'Latakia'**
  String get latakia;

  /// No description provided for @tartus.
  ///
  /// In en, this message translates to:
  /// **'Tartus'**
  String get tartus;

  /// No description provided for @idlib.
  ///
  /// In en, this message translates to:
  /// **'Idlib'**
  String get idlib;

  /// No description provided for @daraa.
  ///
  /// In en, this message translates to:
  /// **'Daraa'**
  String get daraa;

  /// No description provided for @asSuwayda.
  ///
  /// In en, this message translates to:
  /// **'As-Suwayda'**
  String get asSuwayda;

  /// No description provided for @quneitra.
  ///
  /// In en, this message translates to:
  /// **'Quneitra'**
  String get quneitra;

  /// No description provided for @deirEzZor.
  ///
  /// In en, this message translates to:
  /// **'Deir ez-Zor'**
  String get deirEzZor;

  /// No description provided for @raqqa.
  ///
  /// In en, this message translates to:
  /// **'Raqqa'**
  String get raqqa;

  /// No description provided for @alHasakah.
  ///
  /// In en, this message translates to:
  /// **'Al-Hasakah'**
  String get alHasakah;

  /// Booking status chip: pinding
  ///
  /// In en, this message translates to:
  /// **'pinding'**
  String get bookingStatusPinding;

  /// Washer name on booking card
  ///
  /// In en, this message translates to:
  /// **'Al-Miqdad Car Wash'**
  String get bookingsWasherName;

  /// Service row label on booking card
  ///
  /// In en, this message translates to:
  /// **'Requested service'**
  String get bookingsServiceLabel;

  /// Vip service tier label on booking card
  ///
  /// In en, this message translates to:
  /// **'Vip'**
  String get bookingsServiceVip;

  /// Date row label on booking card
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bookingsDateTimeLabel;

  /// Connector between date and time
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get bookingsAtLabel;

  /// Price row label on booking card
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get bookingsPriceLabel;

  /// Menu action for showing booking details
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get bookingsMenuShowDetails;

  /// Washer booking card: full-width CTA
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get washerBookingViewDetails;

  /// Washer booking card: quick action
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get washerBookingAccept;

  /// Washer booking card: quick action
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get washerBookingReject;

  /// Washer booking card: quick action
  ///
  /// In en, this message translates to:
  /// **'Start execution'**
  String get washerBookingStartExecution;

  /// Washer booking card: quick action
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get washerBookingCompleted;

  /// Washer booking card: info row label
  ///
  /// In en, this message translates to:
  /// **'Customer name:'**
  String get washerBookingCustomerNameLabel;

  /// Washer booking card: info row label
  ///
  /// In en, this message translates to:
  /// **'Requested service:'**
  String get washerBookingRequestedServiceLabel;

  /// Washer booking card: info row label
  ///
  /// In en, this message translates to:
  /// **'Appointment:'**
  String get washerBookingAppointmentLabel;

  /// Menu action for cancelling booking
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get bookingsMenuCancelBooking;

  /// Menu action for rating service
  ///
  /// In en, this message translates to:
  /// **'Rate service'**
  String get bookingsMenuRateService;

  /// App bar title for booking details screen
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingDetailsPageTitle;

  /// First section title on booking details screen
  ///
  /// In en, this message translates to:
  /// **'Service details'**
  String get bookingDetailsServiceSectionTitle;

  /// Appointment section title on booking details screen
  ///
  /// In en, this message translates to:
  /// **'Appointment details'**
  String get bookingDetailsAppointmentSectionTitle;

  /// User notes section title on booking details screen
  ///
  /// In en, this message translates to:
  /// **'User notes'**
  String get bookingDetailsUserNotesSectionTitle;

  /// Washer name row label in first card on booking details screen
  ///
  /// In en, this message translates to:
  /// **'Car wash name'**
  String get bookingDetailsWasherNameLabel;

  /// Order date row label in appointment card
  ///
  /// In en, this message translates to:
  /// **'Order date'**
  String get bookingDetailsOrderDateLabel;

  /// Vehicle row label in appointment card
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get bookingDetailsVehicleLabel;

  /// First section title on car wash rating screen
  ///
  /// In en, this message translates to:
  /// **'Service information'**
  String get ratingsServiceInfoSectionTitle;

  /// Question prompt above star rating row
  ///
  /// In en, this message translates to:
  /// **'What is your rating for this service?'**
  String get ratingsYourRatingQuestion;

  /// Label above rating comment field
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience'**
  String get ratingsTellUsExperienceTitle;

  /// Hint text inside rating comment field
  ///
  /// In en, this message translates to:
  /// **'Leave us a comment about your experience'**
  String get ratingsCommentExperienceHint;

  /// Submit rating button label
  ///
  /// In en, this message translates to:
  /// **'Send rating'**
  String get ratingsSendRating;

  /// App bar title for washer owner profile screen
  ///
  /// In en, this message translates to:
  /// **'Washer Profile'**
  String get profileWasherPageTitle;

  /// Primary button on washer profile screen
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileWasherEditProfile;

  /// Placeholder shop name until API data exists
  ///
  /// In en, this message translates to:
  /// **'Mahaba Car Wash'**
  String get profileWasherSampleShopName;

  /// Rating count subtitle under stars on washer profile
  ///
  /// In en, this message translates to:
  /// **'{count} ratings'**
  String profileWasherRatingsCountLine(int count);

  /// Placeholder full address until API data exists
  ///
  /// In en, this message translates to:
  /// **'Damascus - Abbasiyyin Square - Entrance to Al-Qusour Square'**
  String get profileWasherSampleFullAddress;

  /// Placeholder phone displayed on washer profile card
  ///
  /// In en, this message translates to:
  /// **'0987654321'**
  String get profileWasherSamplePhone;

  /// Section title for washer description on profile screen
  ///
  /// In en, this message translates to:
  /// **'About the wash'**
  String get profileWasherAboutTitle;

  /// Placeholder washer description until API provides copy
  ///
  /// In en, this message translates to:
  /// **'At Mahaba Car Wash we deliver professional cleaning with safe, eco-friendly products and a crew that cares about every detail, inside and out. We strive to serve you day after day with clear pricing and a comfortable wait—because your car deserves spotless care from people who love doing the job right.'**
  String get profileWasherDescriptionSample;

  /// App bar title for edit washer profile screen
  ///
  /// In en, this message translates to:
  /// **'Edit washer profile'**
  String get profileWasherEditPageTitle;

  /// Label for wash name field on edit profile
  ///
  /// In en, this message translates to:
  /// **'Washer name'**
  String get profileWasherFieldWasherName;

  /// Hint for wash name field
  ///
  /// In en, this message translates to:
  /// **'Enter wash name'**
  String get profileWasherHintWasherName;

  /// Label for phone field on edit washer profile
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profileWasherFieldPhone;

  /// Hint for phone field
  ///
  /// In en, this message translates to:
  /// **'Enter contact phone number'**
  String get profileWasherHintPhone;

  /// Label for address field
  ///
  /// In en, this message translates to:
  /// **'City and address'**
  String get profileWasherFieldAddress;

  /// Hint for address field
  ///
  /// In en, this message translates to:
  /// **'Enter full wash address'**
  String get profileWasherHintAddress;

  /// Label for work start time
  ///
  /// In en, this message translates to:
  /// **'Opening time'**
  String get profileWasherFieldWorkStart;

  /// Hint for opening time
  ///
  /// In en, this message translates to:
  /// **'Enter opening time'**
  String get profileWasherHintWorkStart;

  /// Label for work end time
  ///
  /// In en, this message translates to:
  /// **'Closing time'**
  String get profileWasherFieldWorkEnd;

  /// Hint for closing time
  ///
  /// In en, this message translates to:
  /// **'Enter closing time'**
  String get profileWasherHintWorkEnd;

  /// Section title on edit washer profile
  ///
  /// In en, this message translates to:
  /// **'Choose the services you offer'**
  String get profileWasherChooseServicesTitle;

  /// Label for description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get profileWasherFieldDescription;

  /// Hint for description field
  ///
  /// In en, this message translates to:
  /// **'Enter wash description'**
  String get profileWasherHintDescription;

  /// Basic tier name
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get profileWasherTierBasic;

  /// VIP tier name
  ///
  /// In en, this message translates to:
  /// **'Vip'**
  String get profileWasherTierVip;

  /// Premium tier name
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get profileWasherTierPremium;

  /// Price field label under tier
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get profileWasherFieldPrice;

  /// Hint for tier price field
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get profileWasherHintPrice;

  /// Primary save button on edit washer profile
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileWasherSaveChanges;

  /// Create washer profile screen title
  ///
  /// In en, this message translates to:
  /// **'Create washer profile'**
  String get profileWasherCreatePageTitle;

  /// Washer logo upload label
  ///
  /// In en, this message translates to:
  /// **'Upload logo'**
  String get profileWasherUploadLogo;

  /// City field label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileWasherFieldCity;

  /// City field hint
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get profileWasherHintCity;

  /// Street address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileWasherFieldStreetAddress;

  /// Street address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get profileWasherHintStreetAddress;

  /// Services list field label
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get profileWasherFieldServicesList;

  /// Services list field hint
  ///
  /// In en, this message translates to:
  /// **'Separate services with a comma'**
  String get profileWasherHintServicesList;

  /// Working hours section title
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get profileWasherWorkingHoursTitle;

  /// Saturday hours field label
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get profileWasherFieldSaturdayHours;

  /// Saturday hours field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. 11:00-15:00'**
  String get profileWasherHintSaturdayHours;

  /// Sunday hours field label
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get profileWasherFieldSundayHours;

  /// Sunday hours field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. 10:00-16:00'**
  String get profileWasherHintSundayHours;

  /// Create washer profile save button
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get profileWasherCreateSave;

  /// Title of total bookings section on ratings screen
  ///
  /// In en, this message translates to:
  /// **'Total bookings'**
  String get showRatingTotalBookings;

  /// All reserved count label on ratings screen
  ///
  /// In en, this message translates to:
  /// **'All Reserved'**
  String get showRatingAllReserved;

  /// Status label for a booking waiting for review
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// Status label when a booking is accepted by the washer
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get bookingStatusAccepted;

  /// Status label when the service has started
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get bookingStatusProgress;

  /// Status label when the service is finished
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// Status label when a booking is canceled
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get bookingStatusCanceled;

  /// Title of average ratings section
  ///
  /// In en, this message translates to:
  /// **'Average ratings'**
  String get showRatingAverageRatings;

  /// Title of users comments section
  ///
  /// In en, this message translates to:
  /// **'Users comments'**
  String get showRatingUsersComments;

  /// App bar title for create SOS screen
  ///
  /// In en, this message translates to:
  /// **'Create SOS'**
  String get createSosTitle;

  /// Label for vehicle dropdown on create SOS
  ///
  /// In en, this message translates to:
  /// **'Choose the vehicle'**
  String get createSosChooseVehicle;

  /// Label for province dropdown on create SOS
  ///
  /// In en, this message translates to:
  /// **'Choose the province'**
  String get createSosChooseProvince;

  /// Hint under province field on create SOS
  ///
  /// In en, this message translates to:
  /// **'* Your current location will be sent automatically'**
  String get createSosLocationAutoHint;

  /// Title for problem description field on create SOS (two lines: heading and hint)
  ///
  /// In en, this message translates to:
  /// **'Enter a description of the problem'**
  String get createSosProblemDescription;

  /// Primary submit button on create SOS
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get createSosSendRequest;

  /// Initial or hint text for problem field (not vehicle or province names)
  ///
  /// In en, this message translates to:
  /// **'Enter the description here'**
  String get createSosSampleProblemText;

  /// App bar title for fuel SOS create screen
  ///
  /// In en, this message translates to:
  /// **'Fuel SOS Create'**
  String get fuelSosCreateTitle;

  /// Vehicle picker field title
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get fuelSosCreateVehicleTitle;

  /// Vehicle picker field hint
  ///
  /// In en, this message translates to:
  /// **'Choose the vehicle you want for the service'**
  String get fuelSosCreateVehicleHint;

  /// Fuel type picker field title
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get fuelSosCreateFuelTypeTitle;

  /// Fuel type picker field hint
  ///
  /// In en, this message translates to:
  /// **'Choose the fuel type you want'**
  String get fuelSosCreateFuelTypeHint;

  /// Quantity field title
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get fuelSosCreateQuantityTitle;

  /// Quantity field hint
  ///
  /// In en, this message translates to:
  /// **'Enter the quantity you want to fill'**
  String get fuelSosCreateQuantityHint;

  /// Notes field title
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fuelSosCreateNotesTitle;

  /// Notes field hint
  ///
  /// In en, this message translates to:
  /// **'Enter any notes you want to add'**
  String get fuelSosCreateNotesHint;

  /// Province picker field title
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get fuelSosCreateProvinceTitle;

  /// Province picker field hint
  ///
  /// In en, this message translates to:
  /// **'Choose the governorate at your current location'**
  String get fuelSosCreateProvinceHint;

  /// Shown when vehicle is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle'**
  String get fuelSosCreateSelectVehicleRequired;

  /// Shown when fuel type is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a fuel type'**
  String get fuelSosCreateSelectFuelTypeRequired;

  /// Shown when quantity is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the quantity'**
  String get fuelSosCreateQuantityRequired;

  /// Shown when province is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a governorate'**
  String get fuelSosCreateSelectProvinceRequired;

  /// Shown when user has no vehicles
  ///
  /// In en, this message translates to:
  /// **'No vehicles found'**
  String get fuelSosCreateNoVehicles;

  /// App bar title for SOS requests list screen
  ///
  /// In en, this message translates to:
  /// **'SOS Requests List'**
  String get sosRequestsListTitle;

  /// Label before SOS request id (value is not translated)
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get sosRequestIdLabel;

  /// Label before vehicle name (value is not translated)
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get sosRequestVehicleLabel;

  /// Label for short problem description (body text is not translated)
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get sosRequestShortDescriptionLabel;

  /// SOS request status badge: finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get sosStatusFinished;

  /// SOS request status badge: in progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get sosStatusInProgress;

  /// SOS request status badge: waiting
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get sosStatusWaiting;

  /// Outlined accept button on SOS request card
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get sosRequestAccept;

  /// Primary button to open SOS request details
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get sosRequestViewDetails;

  /// SOS card footer relative time in hours
  ///
  /// In en, this message translates to:
  /// **'Created {hours} hours ago'**
  String sosRequestCreatedAtHours(int hours);

  /// SOS card footer relative time in minutes
  ///
  /// In en, this message translates to:
  /// **'Created {minutes} min ago'**
  String sosRequestCreatedAtMinutes(int minutes);

  /// App bar title for SOS request details screen
  ///
  /// In en, this message translates to:
  /// **'SOS Details'**
  String get sosDetailsTitle;

  /// Top status banner shown when the SOS request has been accepted
  ///
  /// In en, this message translates to:
  /// **'Request accepted'**
  String get sosDetailsRequestAccepted;

  /// Header label for the request data card on the SOS details screen
  ///
  /// In en, this message translates to:
  /// **'Request data'**
  String get sosDetailsRequestData;

  /// Label before the plate number value (value is not translated)
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get sosDetailsPlateNumberLabel;

  /// Label before the technician name (value is not translated)
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get sosDetailsTechnicianLabel;

  /// Label before the request description text (value is not translated)
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sosDetailsDescriptionLabel;

  /// Header label for the location card on the SOS details screen
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get sosDetailsCurrentLocation;

  /// Label of the track chip on top of the SOS details map
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get sosDetailsTrack;

  /// Primary destructive button to cancel the SOS request
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get sosDetailsCancelRequest;

  /// App bar title for the user fuel orders list screen
  ///
  /// In en, this message translates to:
  /// **'Fuel Orders List'**
  String get fuelOrdersListTitle;

  /// App bar title for the fuel order details screen
  ///
  /// In en, this message translates to:
  /// **'Fuel Order Details'**
  String get fuelOrderDetailsTitle;

  /// Section header for the fuel provider card on order details
  ///
  /// In en, this message translates to:
  /// **'Service provider details'**
  String get fuelOrderDetailsProviderSection;

  /// Header title on the cancel-reason dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel SOS'**
  String get cancelReasonDialogTitle;

  /// Question above the cancel reason text field
  ///
  /// In en, this message translates to:
  /// **'What is the reason for canceling the order?'**
  String get cancelReasonDialogQuestion;

  /// Placeholder in the cancel reason text field
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for canceling the fuel order here...'**
  String get cancelReasonDialogHint;

  /// Dismiss action on the cancel-reason dialog footer
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get cancelReasonDialogBack;

  /// Cancel-reason dialog title on fuel order details
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get fuelCancelReasonDialogTitle;

  /// App bar title for the fuel provider profile screen
  ///
  /// In en, this message translates to:
  /// **'Provider Profile'**
  String get providerProfilePageTitle;

  /// Section title for provider availability toggle
  ///
  /// In en, this message translates to:
  /// **'Work availability'**
  String get providerProfileAvailabilityTitle;

  /// Availability label when the provider is online
  ///
  /// In en, this message translates to:
  /// **'Available now'**
  String get providerProfileAvailableNow;

  /// Availability label when the provider is offline
  ///
  /// In en, this message translates to:
  /// **'Not available now'**
  String get providerProfileNotAvailableNow;

  /// Section title for the provider location card
  ///
  /// In en, this message translates to:
  /// **'Service provider location'**
  String get providerProfileLocationSectionTitle;

  /// Section title for fuel types and prices row
  ///
  /// In en, this message translates to:
  /// **'Services and prices'**
  String get providerProfileServicesAndPricesTitle;

  /// Sample provider name for the profile preview UI
  ///
  /// In en, this message translates to:
  /// **'Khaled Al-Khaled'**
  String get providerProfileSampleName;

  /// Price line on a fuel type card
  ///
  /// In en, this message translates to:
  /// **'price : {price} \$'**
  String providerProfilePriceLine(String price);

  /// App bar title for the fuel provider edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Edit provider profile'**
  String get providerEditProfilePageTitle;

  /// Section title for personal info on provider edit profile
  ///
  /// In en, this message translates to:
  /// **'Your profile information'**
  String get providerEditProfilePersonalInfoTitle;

  /// Label for the provider name field
  ///
  /// In en, this message translates to:
  /// **'Service provider name'**
  String get providerEditProfileProviderNameLabel;

  /// Hint for the provider name field
  ///
  /// In en, this message translates to:
  /// **'Enter the service provider name'**
  String get providerEditProfileProviderNameHint;

  /// Label for the provider phone field
  ///
  /// In en, this message translates to:
  /// **'Service provider phone'**
  String get providerEditProfileProviderPhoneLabel;

  /// Hint for the provider phone field
  ///
  /// In en, this message translates to:
  /// **'Enter the service provider phone'**
  String get providerEditProfileProviderPhoneHint;

  /// Label for the governorate picker
  ///
  /// In en, this message translates to:
  /// **'Choose service provider governorate'**
  String get providerEditProfileGovernorateLabel;

  /// Hint for the governorate picker
  ///
  /// In en, this message translates to:
  /// **'Choose governorate'**
  String get providerEditProfileGovernorateHint;

  /// Label for the address field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get providerEditProfileAddressLabel;

  /// Hint for the address field
  ///
  /// In en, this message translates to:
  /// **'Enter the full address'**
  String get providerEditProfileAddressHint;

  /// Note below the address field about location usage
  ///
  /// In en, this message translates to:
  /// **'* Your location will be used as the provider starting point'**
  String get providerEditProfileLocationNote;

  /// Subtitle on fuel service cards in edit profile
  ///
  /// In en, this message translates to:
  /// **'Activate service and set price'**
  String get providerEditProfileActivateServiceLine;

  /// Save button on provider edit profile
  ///
  /// In en, this message translates to:
  /// **'Save information'**
  String get providerEditProfileSaveInfo;

  /// Sample address on provider edit profile preview form
  ///
  /// In en, this message translates to:
  /// **'Abbasiyeen Square - Al-Qusour Square entrance'**
  String get providerEditProfileSampleAddress;

  /// App bar title for the fuel provider create profile screen
  ///
  /// In en, this message translates to:
  /// **'Create provider profile'**
  String get providerCreateProfilePageTitle;

  /// Save button on provider create profile
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get providerCreateProfileSave;

  /// Title of the fuel price entry dialog
  ///
  /// In en, this message translates to:
  /// **'Set price for {fuelType}'**
  String providerEditProfileSetPriceTitle(String fuelType);

  /// Hint for the price field in the fuel service dialog
  ///
  /// In en, this message translates to:
  /// **'Enter the price'**
  String get providerEditProfileSetPriceHint;

  /// Validation when confirming without a price
  ///
  /// In en, this message translates to:
  /// **'Please enter a price'**
  String get providerEditProfileSetPriceRequired;

  /// App bar title for the fuel provider available orders list
  ///
  /// In en, this message translates to:
  /// **'Available orders'**
  String get providerAvailableOrdersTitle;

  /// Fallback text when an order has no notes
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get providerAvailableOrderNoNotes;

  /// App bar title for the fuel provider order details screen
  ///
  /// In en, this message translates to:
  /// **'Provider order details'**
  String get providerOrderDetailsTitle;

  /// Status banner while the provider has not accepted yet
  ///
  /// In en, this message translates to:
  /// **'Waiting for order acceptance'**
  String get providerOrderDetailsPendingAcceptance;

  /// Section header for customer info on provider order details
  ///
  /// In en, this message translates to:
  /// **'Customer details'**
  String get providerOrderDetailsCustomerSection;

  /// Primary action to accept the order
  ///
  /// In en, this message translates to:
  /// **'Accept order'**
  String get providerOrderDetailsAcceptOrder;

  /// Label when location sharing is enabled
  ///
  /// In en, this message translates to:
  /// **'Share location'**
  String get providerOrderDetailsShareLocationOn;

  /// Label when location sharing is disabled
  ///
  /// In en, this message translates to:
  /// **'Do not share location'**
  String get providerOrderDetailsShareLocationOff;

  /// Title of the dialog when accepting an order with ETA
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival minutes'**
  String get providerOrderDetailsEstimatedArrivalDialogTitle;

  /// Label for the ETA minutes field
  ///
  /// In en, this message translates to:
  /// **'Enter duration in minutes'**
  String get providerOrderDetailsEnterDurationMinutes;

  /// Label for optional notes when accepting an order
  ///
  /// In en, this message translates to:
  /// **'Enter additional notes'**
  String get providerOrderDetailsEnterAdditionalNotes;

  /// App bar title for the fuel provider my orders list
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get providerMyOrdersTitle;

  /// Section title for order totals on provider statistics
  ///
  /// In en, this message translates to:
  /// **'Total orders'**
  String get providerStatisticsTotalOrdersTitle;

  /// Section title for profit totals on provider statistics
  ///
  /// In en, this message translates to:
  /// **'Total profits'**
  String get providerStatisticsTotalProfitsTitle;

  /// Label for total orders count on provider statistics
  ///
  /// In en, this message translates to:
  /// **'All Reserved'**
  String get providerStatisticsAllOrders;

  /// Accessibility label for an advertisement card with no title
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get advertisementSemanticLabel;

  /// Accessibility label for an advertisement card, including its title
  ///
  /// In en, this message translates to:
  /// **'Advertisement: {title}'**
  String advertisementSemanticLabelWithTitle(String title);

  /// Shown when tapping an advertisement fails to open its link
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the advertisement link'**
  String get advertisementLinkOpenFailed;

  /// Maintenance request status filter tab: pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get requestStatusPending;

  /// Maintenance request status filter tab: accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get requestStatusAccepted;

  /// Maintenance request status filter tab: completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get requestStatusCompleted;

  /// Maintenance request status filter tab: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get requestStatusAll;

  /// Spare parts order status filter tab: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get orderStatusAll;

  /// Spare parts order status filter tab: pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// Spare parts order status filter tab: accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get orderStatusAccepted;

  /// Spare parts order status filter tab: processing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// Spare parts order status filter tab: out for delivery
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get orderStatusOutForDelivery;

  /// Spare parts order status filter tab: delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// Spare parts order status filter tab: rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get orderStatusRejected;

  /// Spare parts order status filter tab: cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// Booking status filter tab: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bookingStatusAll;

  /// Forgot password page title
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// Email field hint on forgot password page
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmailHint;

  /// Button to request an OTP for password reset
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendVerificationCode;

  /// Title of the OTP verification card
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get otpCardTitle;

  /// Description above the masked email on the OTP card
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to'**
  String get otpSentDescription;

  /// Primary button on the OTP verification card
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmOtp;

  /// Reset password page title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// Submit button on reset password page
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get resetPasswordButton;

  /// Fallback error when OTP verification fails without a server message
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidVerificationCode;

  /// Fallback error when the OTP has expired
  ///
  /// In en, this message translates to:
  /// **'Verification code expired'**
  String get verificationCodeExpired;

  /// Fallback error when OTP verification attempts are exhausted
  ///
  /// In en, this message translates to:
  /// **'Too many attempts'**
  String get tooManyAttempts;

  /// Fallback success message after resetting the password
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// Label before the OTP expiry countdown (5 minutes), distinct from the resend cooldown
  ///
  /// In en, this message translates to:
  /// **'Code expires in'**
  String get otpExpiresIn;

  /// Shown once the 5-minute OTP validity window ends, and blocks verify submission
  ///
  /// In en, this message translates to:
  /// **'The code has expired, please request a new one.'**
  String get otpExpiredNotice;

  /// Divider label on the login screen, above the Google sign-in button
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// Button label for Google Sign-In on the login screen
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Notifications list filter tab: show all notifications
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsAllFilter;

  /// Notifications list filter tab: show only unread notifications
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsUnreadFilter;

  /// Action in the notifications app bar to mark every notification as read
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// Tooltip/label for the delete action on a single notification
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteNotification;

  /// Relative time label for a notification created less than a minute ago
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationJustNow;

  /// Relative time label for a notification created minutes ago
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String notificationMinutesAgo(int minutes);

  /// Relative time label for a notification created hours ago
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String notificationHoursAgo(int hours);

  /// Relative time label for a notification created yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationYesterday;

  /// Relative time label for a notification created a few days ago
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String notificationDaysAgo(int days);

  /// Title for the province/governorate selection bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Select governorate'**
  String get selectGovernorate;

  /// Ready to get back on the road?
  ///
  /// In en, this message translates to:
  /// **'Ready to get back on the road?'**
  String get readygSummary;
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
