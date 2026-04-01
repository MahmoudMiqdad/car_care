import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // --- App Info ---
  static const String appName = 'Car care';
  static const String appEmail = 'contact@example.com';
  static const String appPhone = '+963xxx-xxx-xxx';

  // --- Localization Codes ---
  static const String langAr = 'ar';
  static const String langEn = 'en';
  static const Locale localeAr = Locale('ar');
  static const Locale localeEn = Locale('en');

  // --- Durations (Times) ---
  static const int animationDurationInMs = 300;
  static const Duration defaultDuration = Duration(milliseconds: 300);

  static const double designWidth = 375;
  static const double designHeight = 812;


  static const double borderRadius = 8;
  static const double buttonHeight = 52;

  /// Maintenance request flow (cards, dashed add tile, priority chips).
  static const double maintenanceRequestCardRadius = 12;
  static const double maintenanceRequestDashedStrokeWidth = 1.5;

  /// Shared shadow blur for [VehicleInfoSurface] / compact vehicle metric pills.
  static const double vehicleInfoSurfaceShadowBlur = 6;

  /// Slightly stronger blur for labeled vehicle info cards (details screen).
  static const double vehicleInfoLabeledCardShadowBlur = 8;



  static const Size designSize = Size(designWidth, designHeight);

  // --- Home (AppBar & layout) ---
  static const double homeAppBarHeight = 64;
  static const double homeAppBarLogoMaxHeight = 200;
  static const double homeAppBarLogoMaxWidth = 250;
  static const double homeAppBarLeadingOuter = 42;
  static const double homeAppBarLeadingIconSize = 28;
  static const double homeAppBarMenuIconSize = 30;
  static const double homeAppBarElevation = 0;
}
