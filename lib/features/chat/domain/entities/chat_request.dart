import 'package:equatable/equatable.dart';

/// Request payload sent to POST /chat.
class ChatRequest extends Equatable {
  final String query;
  final String? filename;

  const ChatRequest({required this.query, this.filename});

  @override
  List<Object> get props => [query, filename ?? ''];
}
