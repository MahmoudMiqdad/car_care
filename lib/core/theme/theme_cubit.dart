import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing app theme mode (light / dark / system).
/// Mirrors LocaleCubit's persistence pattern so both settings behave
/// consistently and survive app restarts.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._secureStorage) : super(ThemeMode.light) {
    _loadSavedThemeMode();
  }

  final SecureStorage _secureStorage;

  /// Load the saved theme mode from storage, defaulting to light.
  Future<void> _loadSavedThemeMode() async {
    final saved = await _secureStorage.getThemeModeValue();
    if (saved != null && saved.isNotEmpty) {
      emit(_fromString(saved));
    }
  }

  /// Change the app theme mode and persist it.
  Future<void> setThemeMode(ThemeMode mode) async {
    await _secureStorage.setThemeModeValue(_toString(mode));
    emit(mode);
  }

  /// Toggle between light and dark (does not touch "system").
  Future<void> toggleTheme() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  bool get isDark => state == ThemeMode.dark;
  bool get isLight => state == ThemeMode.light;
  bool get isSystem => state == ThemeMode.system;

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  static ThemeMode _fromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }
}