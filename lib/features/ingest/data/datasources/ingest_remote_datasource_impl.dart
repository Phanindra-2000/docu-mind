import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:docu_mind/core/config/api_config.dart';
import 'package:docu_mind/core/error/exceptions.dart';
import 'package:docu_mind/core/utils/file_upload.dart';
import 'package:docu_mind/features/ingest/data/datasources/ingest_remote_datasource.dart';
import 'package:docu_mind/features/ingest/data/models/ingest_result_model.dart';

/// Implementation of [IngestRemoteDataSource] using Dio.
///
/// Supports both web (bytes) and native (file path) uploads.
class IngestRemoteDataSourceImpl implements IngestRemoteDataSource {
  final Dio dio;

  const IngestRemoteDataSourceImpl({required this.dio});

  @override
  Future<IngestResultModel> ingestPdf(FileUpload file) async {
    try {
      late final MultipartFile multipartFile;

      if (file.isBytes) {
        // Web: use bytes directly
        multipartFile = MultipartFile.fromBytes(
          file.bytes as Uint8List,
          filename: file.name,
        );
      } else {
        // Native: use file path
        multipartFile = await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        );
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      final response = await dio.post(
        ApiConfig.ingest,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'accept': 'application/json',
          },
        ),
      );

      return IngestResultModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to ingest PDF',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
