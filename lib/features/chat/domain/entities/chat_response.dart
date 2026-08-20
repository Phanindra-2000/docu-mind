import 'package:equatable/equatable.dart';

/// Response received from POST /chat.
class ChatResponse extends Equatable {
  final String answer;
  final List<String> sources;

  const ChatResponse({required this.answer, this.sources = const []});

  @override
  List<Object> get props => [answer, sources];
}
