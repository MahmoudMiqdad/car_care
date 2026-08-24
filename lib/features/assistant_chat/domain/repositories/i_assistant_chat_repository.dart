import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/assistant_chat/domain/entities/assistant_chat_entity.dart';

import 'package:dartz/dartz.dart';

abstract class IAssistantChatRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory();
  Future<Either<Failure, String>> sendMessage(String message);
  Future<Either<Failure, String>> deleteHistory();
}