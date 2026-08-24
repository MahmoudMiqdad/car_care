import 'package:car_care/features/assistant_chat/domain/entities/assistant_chat_entity.dart';

abstract class AssistantChatState {}

class AssistantChatInitial extends AssistantChatState {}

class AssistantChatLoading extends AssistantChatState {}

class AssistantChatLoaded extends AssistantChatState {
  final List<ChatMessageEntity> messages;
  final bool isSending;
  final String? errorMessage;

  AssistantChatLoaded(this.messages, {this.isSending = false, this.errorMessage});
}

class AssistantChatError extends AssistantChatState {
  final String message;
  AssistantChatError(this.message);
}