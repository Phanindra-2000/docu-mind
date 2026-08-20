import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/features/chat/domain/entities/chat_request.dart';
import 'package:docu_mind/features/chat/domain/entities/chat_response.dart';

/// Abstract repository for chat operations.
abstract class ChatRepository {
  /// Sends a chat message and returns the AI response.
  Future<Either<Failure, ChatResponse>> sendMessage(ChatRequest request);
}
