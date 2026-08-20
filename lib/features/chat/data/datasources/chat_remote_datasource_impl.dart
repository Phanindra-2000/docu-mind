import 'package:dio/dio.dart';
import 'package:docu_mind/core/config/api_config.dart';
import 'package:docu_mind/core/error/exceptions.dart';
import 'package:docu_mind/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:docu_mind/features/chat/data/models/chat_request_model.dart';
import 'package:docu_mind/features/chat/data/models/chat_response_model.dart';

/// Implementation of [ChatRemoteDataSource] using Dio.
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  const ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<ChatResponseModel> sendMessage(ChatRequestModel request) async {
    try {
      final response = await dio.post(
        ApiConfig.chat,
        data: request.toJson(),
        options: Options(headers: {'accept': 'application/json'}),
      );

      return ChatResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to send message',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
