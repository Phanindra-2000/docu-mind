import 'package:docu_mind/features/ingest/domain/entities/ingest_result.dart';

/// Data model for the ingest API response.
class IngestResultModel {
  final bool success;
  final String message;
  final String? filename;

  const IngestResultModel({
    required this.success,
    required this.message,
    this.filename,
  });

  /// Parse from the JSON response body.
  factory IngestResultModel.fromJson(Map<String, dynamic> json) {
    return IngestResultModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'Ingested successfully',
      filename: json['filename'] as String?,
    );
  }

  /// Convert to domain entity.
  IngestResult toEntity() =>
      IngestResult(success: success, message: message, filename: filename);
}
