import 'package:equatable/equatable.dart';

/// Domain entity representing a document stored on the server.
class Document extends Equatable {
  final String filename;

  const Document({required this.filename});

  @override
  List<Object> get props => [filename];
}
