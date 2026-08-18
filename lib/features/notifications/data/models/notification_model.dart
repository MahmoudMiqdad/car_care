import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return NotificationModel(
      id: json['id'].toString(),
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: rawData is Map ? Map<String, dynamic>.from(rawData) : const {},
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'] as String)
          : null,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    type: type,
    title: title,
    body: body,
    data: data,
    readAt: readAt,
    createdAt: createdAt,
  );
}

class NotificationsMetaModel {
  final int total;
  final int perPage;
  final int currentPage;
  final int unreadCount;

  const NotificationsMetaModel({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.unreadCount,
  });

  factory NotificationsMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationsMetaModel(
      total: json['total'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 0,
      currentPage: json['current_page'] as int? ?? 1,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}

class NotificationListModel {
  final List<NotificationModel> data;
  final NotificationsMetaModel meta;

  const NotificationListModel({required this.data, required this.meta});

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List? ?? const [];
    return NotificationListModel(
      data: rawList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: NotificationsMetaModel.fromJson(
        json['meta'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
