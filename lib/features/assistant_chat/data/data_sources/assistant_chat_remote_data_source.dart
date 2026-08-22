
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/assistant_chat/data/models/assistant_chat_model.dart';

class AssistantChatRemoteDataSource {
  final ApiService _api;
  const AssistantChatRemoteDataSource(this._api);

  Future<AssistantChatHistoryModel> getHistory() async {
    final res = await _api.get(endPoint: ApiEndpoints.assistantChatHistory);
    return AssistantChatHistoryModel.fromJson(res);
  }

  Future<AssistantSendMessageModel> sendMessage(String message) async {
    final res = await _api.post(
      endPoint: ApiEndpoints.assistantChat,
      data: {'message': message},
    );
    return AssistantSendMessageModel.fromJson(res);
  }

  Future<AssistantMessageResponseModel> deleteHistory() async {
    // ملاحظة: لازم يكون عندك method اسمها delete بالـ ApiService (زي get/post)
    final res = await _api.delete(endPoint: ApiEndpoints.assistantChatHistory);
    return AssistantMessageResponseModel.fromJson(res);
  }
}