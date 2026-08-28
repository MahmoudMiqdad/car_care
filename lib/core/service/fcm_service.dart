import 'dart:async';

import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/core/routing/app_router.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class _NotificationCategory {
  const _NotificationCategory({
    required this.channelId,
    required this.channelName,
    required this.icon,
    required this.sound,
  });

  final String channelId;
  final String channelName;
  final String icon;
  final String sound;
}

class FcmService {
  FcmService(this._apiService, {FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final ApiService _apiService;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _foregroundChannel =
      AndroidNotificationChannel(
        'foreground_high_importance_channel',
        'Notifications',
        description: 'Used for notifications received while the app is open',
        importance: Importance.high,
      );

  static const Map<String, _NotificationCategory> _categoriesByPrefix = {
    'sos_': _NotificationCategory(
      channelId: 'car_care_sos',
      channelName: 'Car Care SOS',
      icon: 'ic_notification_sos',
      sound: 'carcare_sos',
    ),
    'carwash_': _NotificationCategory(
      channelId: 'car_care_wash',
      channelName: 'Car Care Wash',
      icon: 'ic_notification_wash',
      sound: 'carcare_wash',
    ),
    'fuel_': _NotificationCategory(
      channelId: 'car_care_fuel',
      channelName: 'Car Care Fuel',
      icon: 'ic_notification_fuel',
      sound: 'carcare_fuel',
    ),
    'maintenance_': _NotificationCategory(
      channelId: 'car_care_maintenance',
      channelName: 'Car Care Maintenance',
      icon: 'ic_notification_maintenance',
      sound: 'carcare_maintenance',
    ),
    'spare_parts_': _NotificationCategory(
      channelId: 'car_care_spare_parts',
      channelName: 'Car Care Spare Parts',
      icon: 'ic_notification_spare_parts',
      sound: 'carcare_spare_parts',
    ),
  };

  static const Map<String, _NotificationCategory> _categoriesByExactType = {
    'new_sos_request': _NotificationCategory(
      channelId: 'car_care_sos',
      channelName: 'Car Care SOS',
      icon: 'ic_notification_sos',
      sound: 'carcare_sos',
    ),
    'new_emergency_fuel_order': _NotificationCategory(
      channelId: 'car_care_fuel',
      channelName: 'Car Care Fuel',
      icon: 'ic_notification_fuel',
      sound: 'carcare_fuel',
    ),
  };

  static const _NotificationCategory _generalCategory = _NotificationCategory(
    channelId: 'car_care_general',
    channelName: 'Car Care General',
    icon: 'ic_notification_general',
    sound: 'carcare_general',
  );

  static _NotificationCategory _resolveCategory(String? type) {
    if (type == null || type.isEmpty) return _generalCategory;
    final exact = _categoriesByExactType[type];
    if (exact != null) return exact;
    for (final entry in _categoriesByPrefix.entries) {
      if (type.startsWith(entry.key)) return entry.value;
    }
    return _generalCategory;
  }

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _tapSubscription;
  String? _registeredToken;
  bool _localNotificationsInitialized = false;

  String _resolvePlatform() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  }

  Future<void> initializeNotifications() async {
    await _ensureLocalNotificationsInitialized();
  }

  Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localNotificationsInitialized || kIsWeb) return;
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification_general'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.createNotificationChannel(_foregroundChannel);
    for (final category in _categoriesByExactType.values.followedBy(
      _categoriesByPrefix.values,
    )) {
      await androidImplementation?.createNotificationChannel(
        AndroidNotificationChannel(
          category.channelId,
          category.channelName,
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound(category.sound),
        ),
      );
    }
    await androidImplementation?.createNotificationChannel(
      AndroidNotificationChannel(
        _generalCategory.channelId,
        _generalCategory.channelName,
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound(_generalCategory.sound),
      ),
    );
    _localNotificationsInitialized = true;
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    AppRouter.router.go(Routes.notifications);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null || kIsWeb) return;

    final category = _resolveCategory(message.data['type'] as String?);

    await _ensureLocalNotificationsInitialized();
    await _localNotifications.show(
      (message.messageId ?? notification.hashCode.toString()).hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          category.channelId,
          category.channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: category.icon,
          sound: RawResourceAndroidNotificationSound(category.sound),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  void listenToMessages() {
    _foregroundSubscription ??= FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        debugPrint('FCM foreground message received');
      }
      unawaited(_showForegroundNotification(message));
    });

    _tapSubscription ??= FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );
  }

  Future<void> handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    AppRouter.router.go(Routes.notifications);
  }

Future<void> syncTokenForAuthenticatedUser() async {
  try {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();

    if (kDebugMode) {
      debugPrint('FCM TOKEN = $token');
    }

    if (token != null) {
      await _registerToken(token);
    }

    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen(
      _registerToken,
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint('FCM token sync failed: $e');
    }
  }
}

  Future<void> _registerToken(String token) async {
    if (_registeredToken == token) return;
    try {
      await _apiService.post(
        endPoint: ApiEndpoints.devicesRegister,
        data: {'fcm_token': token, 'platform': _resolvePlatform()},
      );
      _registeredToken = token;
    } catch (e) {
      if (kDebugMode) debugPrint('FCM token registration failed: $e');
    }
  }

  Future<void> unregisterCurrentToken() async {
    final token = _registeredToken ?? await _messaging.getToken();
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    if (token == null) return;
    try {
      await _apiService.delete(
        endPoint: ApiEndpoints.devicesUnregister,
        data: {'fcm_token': token},
      );
    } catch (e) {
      if (kDebugMode) debugPrint('FCM token unregistration failed: $e');
    } finally {
      _registeredToken = null;
    }
  }
}
