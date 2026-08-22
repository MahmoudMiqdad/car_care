import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';

enum NotificationsFilter { all, unread }

abstract class NotificationsState {
  final int unreadCount;
  const NotificationsState(this.unreadCount);
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial([super.unreadCount = 0]);
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading(super.unreadCount);
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(super.unreadCount, this.message);
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> items;
  final NotificationsFilter filter;
  final Set<String> markingIds;
  final Set<String> deletingIds;
  final bool isMarkingAll;
  final String? actionError;

  const NotificationsLoaded(
    super.unreadCount, {
    required this.items,
    required this.filter,
    this.markingIds = const {},
    this.deletingIds = const {},
    this.isMarkingAll = false,
    this.actionError,
  });

  NotificationsLoaded copyWith({
    int? unreadCount,
    List<NotificationEntity>? items,
    NotificationsFilter? filter,
    Set<String>? markingIds,
    Set<String>? deletingIds,
    bool? isMarkingAll,
    String? actionError,
    bool clearActionError = false,
  }) {
    return NotificationsLoaded(
      unreadCount ?? this.unreadCount,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      markingIds: markingIds ?? this.markingIds,
      deletingIds: deletingIds ?? this.deletingIds,
      isMarkingAll: isMarkingAll ?? this.isMarkingAll,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }
}
