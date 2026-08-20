import 'package:equatable/equatable.dart';

/// Domain entity for a PDF document.
class PdfDocument extends Equatable {
  final String id;
  final String name;
  final String path;
  final int size;
  final DateTime createdAt;

  const PdfDocument({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, name, path, size, createdAt];
}
