import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/exceptions.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:docu_mind/features/chat/data/models/chat_request_model.dart';
import 'package:docu_mind/features/chat/domain/entities/chat_request.dart';
import 'package:docu_mind/features/chat/domain/entities/chat_response.dart';
import 'package:docu_mind/features/chat/domain/repositories/chat_repository.dart';

/// Concrete implementation of [ChatRepository].
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  const ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatResponse>> sendMessage(ChatRequest request) async {
    try {
      final model = ChatRequestModel.fromEntity(request);
      final response = await remoteDataSource.sendMessage(model);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
