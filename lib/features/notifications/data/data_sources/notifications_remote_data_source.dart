import 'dart:convert';

import 'package:car_care/core/config/env.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/notifications/data/models/notification_model.dart';
import 'package:flutter/foundation.dart';

const int kNotificationsPerPage = 30;

class NotificationsRemoteDataSource {
  final ApiService _apiService;

  NotificationsRemoteDataSource(this._apiService);

  Future<NotificationListModel> getNotifications({bool? unread}) async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.notifications,
      queryParameters: {
        if (unread == true) 'unread': 1,
        'per_page': kNotificationsPerPage,
      },
    );
    return NotificationListModel.fromJson(response);
  }

  Future<int> getUnreadCount() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.notificationsUnreadCount,
    );
    final data = response['data'] as Map<String, dynamic>? ?? const {};
    return data['unread_count'] as int? ?? 0;
  }

  Future<void> markAsRead(String id) async {
    await _apiService.post(endPoint: ApiEndpoints.notificationMarkAsRead(id));
  }

  Future<void> markAllAsRead() async {
    await _apiService.post(endPoint: ApiEndpoints.notificationsMarkAllAsRead);
  }

  Future<void> deleteNotification(String id) async {
    await _apiService.delete(endPoint: ApiEndpoints.notificationById(id));
  }

  /// Laravel broadcasting auth for a private Reverb/Pusher channel — reuses
  /// the same ApiService/AuthInterceptor stack as every other request.
  ///
  /// `Broadcast::routes()` registers this route outside routes/api.php's
  /// `/api` prefix, so a plain relative endPoint would resolve under
  /// ApiService's `/api`-prefixed baseUrl and 404. Passing an absolute
  /// `http(s)://` URL makes Dio use it as-is instead of combining it with
  /// baseUrl, while the request still goes through the same Dio instance
  /// (and therefore the same AuthInterceptor Bearer-token attachment).
  Future<String?> broadcastAuth({
    required String socketId,
    required String channelName,
  }) async {
    final response = await _apiService.post(
      endPoint: '${Env.apiRootUrl}${ApiEndpoints.broadcastingAuth}',
      data: {'socket_id': socketId, 'channel_name': channelName},
    );

    if (kDebugMode) {
      debugPrint('Broadcast auth response keys: ${response.keys.toList()}');
    }

    return _extractAuth(response);
  }

  /// Reverb/Pusher's broadcasting-auth response is a bare `{"auth": "..."}`
  /// object — checked first, since that's the real shape confirmed on this
  /// endpoint. [ApiService] only auto-decodes the body into a Map when the
  /// server's Content-Type header is recognized as JSON; when it isn't
  /// (this route bypasses the app's normal API middleware/response
  /// pipeline, so its headers can differ from every other endpoint), the
  /// raw JSON text arrives here wrapped as `{"data": "<json string>"}`
  /// instead — this unwraps that fallback shape rather than assuming it.
  String? _extractAuth(Map<String, dynamic> response) {
    final direct = response['auth'];
    if (direct is String && direct.isNotEmpty) return direct;

    final data = response['data'];
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          final auth = decoded['auth'];
          if (auth is String && auth.isNotEmpty) return auth;
        }
      } catch (_) {
        // Not JSON — nothing more we can safely extract.
      }
    } else if (data is Map<String, dynamic>) {
      final auth = data['auth'];
      if (auth is String && auth.isNotEmpty) return auth;
    }

    return null;
  }
}
