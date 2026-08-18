import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:car_care/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationsRepositoryImpl implements INotificationsRepository {
  final NotificationsRemoteDataSource _remote;

  NotificationsRepositoryImpl(this._remote);

  Future<Either<Failure, T>> _call<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, NotificationsListResult>> getNotifications({
    bool? unread,
  }) => _call(() async {
    final result = await _remote.getNotifications(unread: unread);
    return NotificationsListResult(
      items: result.data.map((e) => e.toEntity()).toList(),
      unreadCount: result.meta.unreadCount,
    );
  });

  @override
  Future<Either<Failure, int>> getUnreadCount() =>
      _call(() => _remote.getUnreadCount());

  @override
  Future<Either<Failure, void>> markAsRead(String id) =>
      _call(() => _remote.markAsRead(id));

  @override
  Future<Either<Failure, void>> markAllAsRead() =>
      _call(() => _remote.markAllAsRead());

  @override
  Future<Either<Failure, void>> deleteNotification(String id) =>
      _call(() => _remote.deleteNotification(id));

  @override
  Future<Either<Failure, String>> getBroadcastAuth({
    required String socketId,
    required String channelName,
  }) => _call(() async {
    final auth = await _remote.broadcastAuth(
      socketId: socketId,
      channelName: channelName,
    );
    if (auth == null || auth.isEmpty) {
      throw ServerExpcptions(
        error: const Failure(message: 'تعذر التحقق من صلاحية القناة'),
      );
    }
    return auth;
  });
}
