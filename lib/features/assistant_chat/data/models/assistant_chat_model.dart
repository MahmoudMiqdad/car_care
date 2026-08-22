
class AssistantChatHistoryModel {
  final bool? success;
  final List<ChatMessageData> data;

  AssistantChatHistoryModel({this.success, required this.data});

  factory AssistantChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      AssistantChatHistoryModel(
        success: json['success'],
        data: json['data'] != null
            ? List.from(json['data']).map((e) => ChatMessageData.fromJson(e)).toList()
            : [],
      );
}

class ChatMessageData {
  final String? role;
  final String? content;

  ChatMessageData({this.role, this.content});

  factory ChatMessageData.fromJson(Map<String, dynamic> json) =>
      ChatMessageData(role: json['role'], content: json['content']);
}

class AssistantSendMessageModel {
  final bool? success;
  final AssistantAnswerData? data;

  AssistantSendMessageModel({this.success, this.data});

  factory AssistantSendMessageModel.fromJson(Map<String, dynamic> json) =>
      AssistantSendMessageModel(
        success: json['success'],
        data: json['data'] != null ? AssistantAnswerData.fromJson(json['data']) : null,
      );
}

class AssistantAnswerData {
  final String? answer;

  AssistantAnswerData({this.answer});

  factory AssistantAnswerData.fromJson(Map<String, dynamic> json) =>
      AssistantAnswerData(answer: json['answer']);
}


class AssistantMessageResponseModel {
  final bool? success;
  final String? message;

  AssistantMessageResponseModel({this.success, this.message});

  factory AssistantMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      AssistantMessageResponseModel(success: json['success'], message: json['message']);
}