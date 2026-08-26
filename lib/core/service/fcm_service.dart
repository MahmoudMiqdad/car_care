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

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _tapSubscription;
  String? _registeredToken;
  bool _localNotificationsInitialized = false;

  String _resolvePlatform() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  }

  Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localNotificationsInitialized || kIsWeb) return;
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_foregroundChannel);
    _localNotificationsInitialized = true;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null || kIsWeb) return;

    await _ensureLocalNotificationsInitialized();
    await _localNotifications.show(
      (message.messageId ?? notification.hashCode.toString()).hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _foregroundChannel.id,
          _foregroundChannel.name,
          channelDescription: _foregroundChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
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
      if (token != null) {
        await _registerToken(token);
      }
      _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen(
        _registerToken,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('FCM token sync failed: $e');
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
