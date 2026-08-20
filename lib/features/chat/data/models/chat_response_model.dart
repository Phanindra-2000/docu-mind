import 'package:docu_mind/features/chat/domain/entities/chat_response.dart';

/// Deserializable model for the chat API response.
class ChatResponseModel {
  final String answer;
  final List<String> sources;

  const ChatResponseModel({required this.answer, this.sources = const []});

  /// Parse from the JSON response body.
  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      answer: json['answer'] as String? ?? json['response'] as String? ?? '',
      sources: (json['sources'] as List?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
    );
  }

  /// Convert to domain entity.
  ChatResponse toEntity() => ChatResponse(answer: answer, sources: sources);
}
