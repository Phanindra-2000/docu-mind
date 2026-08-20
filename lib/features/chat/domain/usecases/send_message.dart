import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/usecase/usecase.dart';
import 'package:docu_mind/features/chat/domain/entities/chat_request.dart';
import 'package:docu_mind/features/chat/domain/entities/chat_response.dart';
import 'package:docu_mind/features/chat/domain/repositories/chat_repository.dart';

/// Use case: send a message to the chat API.
class SendMessage extends UseCase<ChatResponse, ChatRequest> {
  final ChatRepository repository;

  const SendMessage(this.repository);

  @override
  Future<Either<Failure, ChatResponse>> call(ChatRequest params) {
    return repository.sendMessage(params);
  }
}
