import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/core/providers.dart';
import 'package:docu_mind/features/chat/data/datasources/chat_remote_datasource_impl.dart';
import 'package:docu_mind/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:docu_mind/features/chat/domain/entities/message.dart';
import 'package:docu_mind/features/chat/domain/entities/chat_request.dart';
import 'package:docu_mind/features/chat/domain/usecases/send_message.dart';

// ── Data layer providers ─────────────────────────────────

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSourceImpl>(
  (ref) => ChatRemoteDataSourceImpl(dio: ref.watch(dioProvider)),
);

final chatRepositoryProvider = Provider<ChatRepositoryImpl>(
  (ref) => ChatRepositoryImpl(
    remoteDataSource: ref.watch(chatRemoteDataSourceProvider),
  ),
);

// ── Use case providers ───────────────────────────────────

final sendMessageProvider = Provider<SendMessage>(
  (ref) => SendMessage(ref.watch(chatRepositoryProvider)),
);

// ── State (Notifier) ─────────────────────────────────────

/// Holds the chat messages list and manages sending.
class ChatNotifier extends Notifier<List<Message>> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @override
  List<Message> build() => [];

  Future<void> send(String query, {String? filename}) async {
    // Add user message
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: query,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    state = [...state, userMessage];

    // Set loading
    _isLoading = true;
    ref.notifyListeners();

    final request = ChatRequest(query: query, filename: filename);
    final result = await ref.read(sendMessageProvider).call(request);

    result.fold(
      (failure) {
        _isLoading = false;
        ref.notifyListeners();
        // Add error as system message
        final errorMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Error: ${failure.message}',
          role: MessageRole.system,
          timestamp: DateTime.now(),
        );
        state = [...state, errorMessage];
      },
      (response) {
        final assistantMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: response.answer,
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
        );
        state = [...state, assistantMessage];
        _isLoading = false;
        ref.notifyListeners();
      },
    );
  }

  void clear() {
    state = [];
    _isLoading = false;
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<Message>>(
  ChatNotifier.new,
);
