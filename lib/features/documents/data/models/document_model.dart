import 'package:docu_mind/features/documents/domain/entities/document.dart';

/// Data model that maps the API response to the domain entity.
class DocumentModel extends Document {
  const DocumentModel({required super.filename});

  /// The server may return documents as a list of strings or objects.
  /// Handles both formats.
  factory DocumentModel.fromJson(dynamic json) {
    if (json is String) {
      return DocumentModel(filename: json);
    }
    if (json is Map<String, dynamic>) {
      return DocumentModel(
        filename: json['filename'] as String? ?? json['name'] as String? ?? '',
      );
    }
    return DocumentModel(filename: json.toString());
  }

  /// Convert to domain entity.
  Document toEntity() => this;
}
