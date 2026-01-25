import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // --- App Info ---
  static const String appName = 'Qatrah';
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



  static const Size designSize = Size(designWidth, designHeight);

}
