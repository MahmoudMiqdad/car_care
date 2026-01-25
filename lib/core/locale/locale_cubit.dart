import 'dart:ui';

import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// Cubit for managing app locale/language state
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._secureStorage) : super(const Locale('ar')) {
    _loadSavedLocale();
  }

  final SecureStorage _secureStorage;

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('ar'), // Arabic - Default
    Locale('en'), // English
  ];

  /// Load saved locale from storage
  Future<void> _loadSavedLocale() async {
    final savedLocale = await _secureStorage.getLocalizedValue();
    if (savedLocale != null && savedLocale.isNotEmpty) {
      final locale = Locale(savedLocale);
      if (supportedLocales.contains(locale)) {
        emit(locale);
      }
    }
    // If no saved locale, keep Arabic as default (already set in super)
  }

  /// Change the app locale
  Future<void> setLocale(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      await _secureStorage.setLocalizedValue(locale.languageCode);
      emit(locale);
    }
  }

  /// Toggle between Arabic and English
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(newLocale);
  }

  /// Check if current locale is Arabic
  bool get isArabic => state.languageCode == 'ar';

  /// Check if current locale is English
  bool get isEnglish => state.languageCode == 'en';
}
