import 'package:docu_mind/features/home/domain/entities/pdf_document.dart';

/// Data model that mirrors the domain entity with JSON serialization.
class PdfDocumentModel extends PdfDocument {
  const PdfDocumentModel({
    required super.id,
    required super.name,
    required super.path,
    required super.size,
    required super.createdAt,
  });

  factory PdfDocumentModel.fromJson(Map<String, dynamic> json) {
    return PdfDocumentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      size: json['size'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert model to domain entity (useful if model has extra fields).
  PdfDocument toEntity() => this;
}
