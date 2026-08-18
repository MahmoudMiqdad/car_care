import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';

abstract class INotificationsRepository {
  Future<Either<Failure, NotificationsListResult>> getNotifications({
    bool? unread,
  });

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, void>> markAsRead(String id);

  Future<Either<Failure, void>> markAllAsRead();

  Future<Either<Failure, void>> deleteNotification(String id);

  Future<Either<Failure, String>> getBroadcastAuth({
    required String socketId,
    required String channelName,
  });
}
