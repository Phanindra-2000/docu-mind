import 'package:equatable/equatable.dart';

/// Represents a single message in the chat.
class Message extends Equatable {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, content, role, timestamp];
}

enum MessageRole {
  user,
  assistant,
  system,
}
