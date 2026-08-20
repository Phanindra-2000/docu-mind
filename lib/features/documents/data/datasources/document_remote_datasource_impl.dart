import 'package:dio/dio.dart';
import 'package:docu_mind/core/config/api_config.dart';
import 'package:docu_mind/core/error/exceptions.dart';
import 'package:docu_mind/features/documents/data/datasources/document_remote_datasource.dart';
import 'package:docu_mind/features/documents/data/models/document_model.dart';

/// Implementation of [DocumentRemoteDataSource] using Dio.
class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final Dio dio;

  const DocumentRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DocumentModel>> listDocuments() async {
    try {
      final response = await dio.get(ApiConfig.documents);

      final data = response.data;

      // Handle both list of strings and list of objects
      if (data is List) {
        return data
            .map((json) => DocumentModel.fromJson(json))
            .toList();
      }

      // If the response has a nested key like { documents: [...] }
      if (data is Map<String, dynamic> && data.containsKey('documents')) {
        final list = data['documents'] as List;
        return list
            .map((json) => DocumentModel.fromJson(json))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to list documents',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteDocument(String filename) async {
    try {
      await dio.delete('${ApiConfig.documents}/$filename');
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete document',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
