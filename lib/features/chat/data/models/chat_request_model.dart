import 'package:docu_mind/features/chat/domain/entities/chat_request.dart';

/// Serializable model for the chat request payload.
class ChatRequestModel {
  final String query;
  final String? filename;

  const ChatRequestModel({required this.query, this.filename});

  /// Convert from domain entity.
  factory ChatRequestModel.fromEntity(ChatRequest entity) {
    return ChatRequestModel(
      query: entity.query,
      filename: entity.filename,
    );
  }

  /// Serialize to JSON for the API body.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'query': query,
    };
    if (filename != null && filename!.isNotEmpty) {
      json['filename'] = filename;
    }
    return json;
  }
}
