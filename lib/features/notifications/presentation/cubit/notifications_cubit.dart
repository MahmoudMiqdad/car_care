import 'dart:async';

import 'package:car_care/core/service/pusher_service.dart';
import 'package:car_care/features/notifications/data/models/notification_model.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:car_care/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final INotificationsRepository _repo;
  final PusherService _pusher;

  int? _realtimeUserId;

  NotificationsCubit(this._repo, {PusherService? pusher})
    : _pusher = pusher ?? PusherService(),
      super(const NotificationsInitial());

  NotificationEntity? _findById(List<NotificationEntity> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<void> fetchUnreadCount() async {
    final result = await _repo.getUnreadCount();
    result.fold((_) {}, (count) => emit(_withUnreadCount(count)));
  }

  NotificationsState _withUnreadCount(int count) {
    final current = state;
    if (current is NotificationsLoaded)
      return current.copyWith(unreadCount: count);
    if (current is NotificationsError) {
      return NotificationsError(count, current.message);
    }
    if (current is NotificationsLoading) return NotificationsLoading(count);
    return NotificationsInitial(count);
  }

  Future<void> getNotifications({
    bool silent = false,
    NotificationsFilter filter = NotificationsFilter.all,
  }) async {
    final current = state;
    final loadedForSilentRefresh = silent && current is NotificationsLoaded
        ? current
        : null;

    if (loadedForSilentRefresh == null) {
      emit(NotificationsLoading(state.unreadCount));
    }

    final result = await _repo.getNotifications(
      unread: filter == NotificationsFilter.unread ? true : null,
    );

    result.fold(
      (failure) {
        if (loadedForSilentRefresh != null) {
          emit(
            loadedForSilentRefresh.copyWith(
              actionError: failure.displayMessage,
            ),
          );
        } else {
          emit(NotificationsError(state.unreadCount, failure.displayMessage));
        }
      },
      (data) => emit(
        NotificationsLoaded(
          data.unreadCount,
          items: data.items,
          filter: filter,
        ),
      ),
    );
  }

  Future<void> setFilter(NotificationsFilter filter) async {
    final current = state;
    if (current is NotificationsLoaded && current.filter == filter) return;
    await getNotifications(filter: filter);
  }

  Future<void> markAsRead(String id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    if (current.markingIds.contains(id)) return;

    final target = _findById(current.items, id);
    if (target == null || !target.isUnread) return;

    emit(current.copyWith(markingIds: {...current.markingIds, id}));

    final result = await _repo.markAsRead(id);

    result.fold(
      (failure) => emit(
        current.copyWith(
          markingIds: current.markingIds.where((e) => e != id).toSet(),
          actionError: failure.displayMessage,
        ),
      ),
      (_) {
        final newUnreadCount = (current.unreadCount - 1).clamp(0, 1 << 30);
        final updatedItems = current.filter == NotificationsFilter.unread
            ? current.items.where((n) => n.id != id).toList()
            : [
                for (final n in current.items)
                  if (n.id == id) n.copyWith(readAt: DateTime.now()) else n,
              ];
        emit(
          NotificationsLoaded(
            newUnreadCount,
            items: updatedItems,
            filter: current.filter,
            deletingIds: current.deletingIds,
          ),
        );
      },
    );
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    if (current.isMarkingAll || current.unreadCount == 0) return;

    emit(current.copyWith(isMarkingAll: true));

    final result = await _repo.markAllAsRead();

    result.fold(
      (failure) => emit(
        current.copyWith(
          isMarkingAll: false,
          actionError: failure.displayMessage,
        ),
      ),
      (_) {
        emit(
          NotificationsLoaded(
            0,
            items: current.filter == NotificationsFilter.unread
                ? const []
                : [
                    for (final n in current.items)
                      n.isUnread ? n.copyWith(readAt: DateTime.now()) : n,
                  ],
            filter: current.filter,
            deletingIds: current.deletingIds,
          ),
        );
      },
    );
  }

  Future<void> deleteNotification(String id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    if (current.deletingIds.contains(id)) return;

    final target = _findById(current.items, id);

    emit(current.copyWith(deletingIds: {...current.deletingIds, id}));

    final result = await _repo.deleteNotification(id);

    result.fold(
      (failure) => emit(
        current.copyWith(
          deletingIds: current.deletingIds.where((e) => e != id).toSet(),
          actionError: failure.displayMessage,
        ),
      ),
      (_) {
        final remaining = current.items.where((n) => n.id != id).toList();
        final wasUnread = target?.isUnread ?? false;
        emit(
          NotificationsLoaded(
            wasUnread
                ? (current.unreadCount - 1).clamp(0, 1 << 30)
                : current.unreadCount,
            items: remaining,
            filter: current.filter,
            markingIds: current.markingIds,
          ),
        );
      },
    );
  }

  void clearActionError() {
    final current = state;
    if (current is NotificationsLoaded && current.actionError != null) {
      emit(current.copyWith(clearActionError: true));
    }
  }

  void reset() {
    unsubscribeRealtime();
    if (!isClosed) emit(const NotificationsInitial());
  }

  static const String _realtimeEvent = 'notification.created';

  String _channelNameFor(int userId) => 'private-notifications.$userId';

  void subscribeRealtime(int userId) {
    if (_realtimeUserId != userId) {
      unsubscribeRealtime();
      _realtimeUserId = userId;
    }

    unawaited(
      _pusher.subscribeToPrivateChannel(
        channelName: _channelNameFor(userId),
        eventName: _realtimeEvent,
        onEvent: (data) => _handleRealtimeEvent(userId, data),
        authProvider: ({required socketId, required channelName}) async {
          final result = await _repo.getBroadcastAuth(
            socketId: socketId,
            channelName: channelName,
          );
          return result.fold((_) => null, (auth) => auth);
        },
      ),
    );
  }

  void unsubscribeRealtime() {
    final userId = _realtimeUserId;
    if (userId != null) {
      unawaited(_pusher.unsubscribeFromPrivateChannel(_channelNameFor(userId)));
    }
    _realtimeUserId = null;
  }

  void _handleRealtimeEvent(int forUserId, Map<String, dynamic> data) {
    if (_realtimeUserId != forUserId) return;

    try {
      final entity = NotificationModel.fromJson(data).toEntity();
      insertRealtimeNotification(entity);
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to parse realtime notification: $e');
    }
  }

  @visibleForTesting
  void insertRealtimeNotification(NotificationEntity notification) {
    if (isClosed) return;
    final current = state;

    if (current is! NotificationsLoaded) {
      if (notification.isUnread) {
        emit(_withUnreadCount(state.unreadCount + 1));
      }
      return;
    }

    final alreadyExists = current.items.any((n) => n.id == notification.id);
    if (alreadyExists) return;

    final matchesCurrentFilter =
        current.filter == NotificationsFilter.all || notification.isUnread;
    final updatedItems = matchesCurrentFilter
        ? [notification, ...current.items]
        : current.items;
    final updatedUnreadCount = notification.isUnread
        ? current.unreadCount + 1
        : current.unreadCount;

    emit(
      current.copyWith(items: updatedItems, unreadCount: updatedUnreadCount),
    );
  }
}
