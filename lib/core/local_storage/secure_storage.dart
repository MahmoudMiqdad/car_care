// مسؤول عن تخزين بيانات الجلسة والمصادقة محليًا بأمان وإدارة مسحها.
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum DbKeys {
  username,
  password,
  token,
  refreshToken,
  role,
  roles,
  admin,
  premium,
  logged,
  local,
  firstOpen,
}

class SecureStorage {
  // Constructor that accepts FlutterSecureStorage
  SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _storage;

  Future<T?> _performOperation<T>(Future<T?> Function() operation) async {
    try {
      return await operation();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in SecureStorage operation: $e');
      }
      return null;
    }
  }

  Future<void> setValue(DbKeys key, String value) async {
    await _performOperation(() => _storage.write(key: key.name, value: value));
  }

  Future<String?> getValue(DbKeys key) async {
    return _performOperation(() => _storage.read(key: key.name));
  }

  Future<void> deleteValue(DbKeys key) async {
    await _performOperation(() => _storage.delete(key: key.name));
  }

  Future<void> deleteAll() async {
    await _performOperation(_storage.deleteAll);
  }

  Future<void> setBoolValue(DbKeys key, bool value) async {
    await setValue(key, value.toString());
  }

  Future<bool?> getBoolValue(DbKeys key) async {
    final value = await getValue(key);
    return value != null ? value.toLowerCase() == 'true' : null;
  }

  // Enhanced methods
  Future<void> setFirstOpenStatus(bool isFirstOpen) =>
      setBoolValue(DbKeys.firstOpen, isFirstOpen);
  Future<bool?> getFirstOpenStatus() => getBoolValue(DbKeys.firstOpen);

  Future<void> setLocalizedValue(String languageCode) =>
      setValue(DbKeys.local, languageCode);
  Future<String?> getLocalizedValue() => getValue(DbKeys.local);

  Future<void> setAdminStatus(bool isAdmin) =>
      setBoolValue(DbKeys.admin, isAdmin);
  Future<bool?> getAdminStatus() => getBoolValue(DbKeys.admin);

  Future<void> setPremiumStatus(bool isPremium) =>
      setBoolValue(DbKeys.premium, isPremium);
  Future<bool?> getPremiumStatus() => getBoolValue(DbKeys.premium);

  Future<void> setLoggedInStatus(bool isLoggedIn) =>
      setBoolValue(DbKeys.logged, isLoggedIn);
  Future<bool?> getLoggedInStatus() => getBoolValue(DbKeys.logged);

  Future<void> setUserName(String username) =>
      setValue(DbKeys.username, username);
  Future<String?> getUserName() => getValue(DbKeys.username);

  Future<void> setPassword(String password) =>
      setValue(DbKeys.password, password);
  Future<String?> getPassword() => getValue(DbKeys.password);
  /////////
  //Future<void> setToken(String token) => setValue(DbKeys.token, token);
  Future<void> setToken(String token) => setValue(DbKeys.token, token);
  Future<String?> getToken() => getValue(DbKeys.token);
  Future<void> deleteToken() => deleteValue(DbKeys.token);

  // New methods for refresh token (needed for AuthInterceptor)
  Future<void> setRefreshToken(String refreshToken) =>
      setValue(DbKeys.refreshToken, refreshToken);
  Future<String?> getRefreshToken() => getValue(DbKeys.refreshToken);

  Future<void> setRole(String role) => setValue(DbKeys.role, role);
  Future<String?> getRole() => getValue(DbKeys.role);

  // Primary role — same key as role, explicit naming for clarity
  Future<void> setPrimaryRole(String role) => setRole(role);
  Future<String?> getPrimaryRole() => getRole();

  // Full roles list stored as comma-separated string
  Future<void> setRoles(List<String> rolesList) =>
      setValue(DbKeys.roles, rolesList.join(','));

  Future<List<String>> getRoles() async {
    final value = await getValue(DbKeys.roles);
    if (value == null || value.isEmpty) return [];
    return value.split(',').where((r) => r.isNotEmpty).toList();
  }

  Future<void> clearRoles() async {
    await deleteValue(DbKeys.role);
    await deleteValue(DbKeys.roles);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all authentication data including roles and stored credentials
  Future<void> clearAuth() async {
    await deleteToken();
    await deleteValue(DbKeys.refreshToken);
    await setLoggedInStatus(false);
    await clearRoles();
    await deleteValue(DbKeys.username);
    await deleteValue(DbKeys.password);
  }

  // Method for checking if a key exists
  Future<bool> containsKey(DbKeys key) async {
    return await _performOperation(() => _storage.containsKey(key: key.name)) ??
        false;
  }

  // Method for getting all keys
  Future<Map<String, String>> getAllKeys() async {
    return await _performOperation(_storage.readAll) ?? {};
  }
}
