import 'package:car_care/features/assistant_chat/domain/entities/assistant_chat_entity.dart';

import 'package:car_care/features/assistant_chat/domain/repositories/i_assistant_chat_repository.dart';
import 'package:car_care/features/assistant_chat/presentation/cubit/assistant_chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantChatCubit extends Cubit<AssistantChatState> {
  final IAssistantChatRepository _repo;
  AssistantChatCubit(this._repo) : super(AssistantChatInitial());

  List<ChatMessageEntity> _messages = [];
  bool _sending = false;

  Future<void> getHistory() async {
    emit(AssistantChatLoading());
    final res = await _repo.getHistory();
    res.fold(
      (l) => emit(AssistantChatError(l.displayMessage)),
      (r) {
        _messages = r;
        emit(AssistantChatLoaded(List.of(_messages)));
      },
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _sending) return;

    _messages = [..._messages, ChatMessageEntity(role: 'user', content: text)];
    _sending = true;
    emit(AssistantChatLoaded(List.of(_messages), isSending: true));

    final res = await _repo.sendMessage(text);
    _sending = false;

    res.fold(
      (l) => emit(AssistantChatLoaded(List.of(_messages), errorMessage: l.displayMessage)),
      (answer) {
        _messages = [..._messages, ChatMessageEntity(role: 'assistant', content: answer)];
        emit(AssistantChatLoaded(List.of(_messages)));
      },
    );
  }

  Future<void> deleteHistory() async {
    final res = await _repo.deleteHistory();
    res.fold(
      (l) => emit(AssistantChatLoaded(List.of(_messages), errorMessage: l.displayMessage)),
      (_) {
        _messages = [];
        emit(AssistantChatLoaded(const []));
      },
    );
  }
}