class NotificationEntity {
  final String id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.readAt,
    required this.createdAt,
  });

  bool get isUnread => readAt == null;

  NotificationEntity copyWith({DateTime? readAt}) {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      body: body,
      data: data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }
}

class NotificationsListResult {
  final List<NotificationEntity> items;
  final int unreadCount;

  const NotificationsListResult({required this.items, required this.unreadCount});
}
