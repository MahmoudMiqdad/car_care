import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/assistant_chat/data/data_sources/assistant_chat_remote_data_source.dart';
import 'package:car_care/features/assistant_chat/data/models/assistant_chat_model.dart';
import 'package:car_care/features/assistant_chat/domain/entities/assistant_chat_entity.dart';
import 'package:car_care/features/assistant_chat/domain/repositories/i_assistant_chat_repository.dart';
import 'package:dartz/dartz.dart';

class AssistantChatRepositoryImpl implements IAssistantChatRepository {
  final AssistantChatRemoteDataSource _remote;
  AssistantChatRepositoryImpl(this._remote);

  Future<Either<Failure, T>> _call<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (e) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  ChatMessageEntity _mapMessage(ChatMessageData d) =>
      ChatMessageEntity(role: d.role, content: d.content);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory() =>
      _call(() async => (await _remote.getHistory()).data.map(_mapMessage).toList());

  @override
  Future<Either<Failure, String>> sendMessage(String message) => _call(
        () async => (await _remote.sendMessage(message)).data?.answer ?? '',
      );

  @override
  Future<Either<Failure, String>> deleteHistory() =>
      _call(() async => (await _remote.deleteHistory()).message ?? '');
}