import 'package:docu_mind/features/chat/data/models/chat_request_model.dart';
import 'package:docu_mind/features/chat/data/models/chat_response_model.dart';

/// Abstract remote data source for chat API calls.
abstract class ChatRemoteDataSource {
  /// POST /chat
  Future<ChatResponseModel> sendMessage(ChatRequestModel request);
}
