import 'package:equatable/equatable.dart';

/// Domain entity representing the result of a PDF ingest operation.
class IngestResult extends Equatable {
  final bool success;
  final String message;
  final String? filename;

  const IngestResult({
    required this.success,
    required this.message,
    this.filename,
  });

  @override
  List<Object> get props => [success, message, filename ?? ''];
}
