import 'dart:convert';

import 'package:car_care/core/config/env.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/notifications/data/models/notification_model.dart';

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

  Future<String?> broadcastAuth({
    required String socketId,
    required String channelName,
  }) async {
    final response = await _apiService.post(
      endPoint: '${Env.apiRootUrl}${ApiEndpoints.broadcastingAuth}',
      data: {'socket_id': socketId, 'channel_name': channelName},
    );

    return _extractAuth(response);
  }

  String? _extractAuth(Map<String, dynamic> response) => _findAuth(response, 0);

  String? _findAuth(dynamic value, int depth) {
    if (depth > 4) return null;

    if (value is Map) {
      final direct = value['auth'];
      if (direct is String && direct.isNotEmpty) return direct;
      for (final nested in value.values) {
        final found = _findAuth(nested, depth + 1);
        if (found != null) return found;
      }
      return null;
    }

    if (value is List) {
      for (final item in value) {
        final found = _findAuth(item, depth + 1);
        if (found != null) return found;
      }
      return null;
    }

    if (value is String && value.isNotEmpty) {
      final trimmed = value.trimLeft();
      if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return null;
      try {
        return _findAuth(jsonDecode(value), depth + 1);
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}
