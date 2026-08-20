import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/core/providers.dart';
import 'package:docu_mind/features/documents/data/datasources/document_remote_datasource_impl.dart';
import 'package:docu_mind/features/documents/data/repositories/document_repository_impl.dart';
import 'package:docu_mind/features/documents/domain/entities/document.dart';
import 'package:docu_mind/features/documents/domain/usecases/list_documents.dart';
import 'package:docu_mind/features/documents/domain/usecases/delete_document.dart';
import 'package:docu_mind/core/usecase/usecase.dart';

// ── Data layer providers ─────────────────────────────────

final documentRemoteDataSourceProvider = Provider<DocumentRemoteDataSourceImpl>(
  (ref) => DocumentRemoteDataSourceImpl(dio: ref.watch(dioProvider)),
);

final documentRepositoryProvider = Provider<DocumentRepositoryImpl>(
  (ref) => DocumentRepositoryImpl(
    remoteDataSource: ref.watch(documentRemoteDataSourceProvider),
  ),
);

// ── Use case providers ───────────────────────────────────

final listDocumentsProvider = Provider<ListDocuments>(
  (ref) => ListDocuments(ref.watch(documentRepositoryProvider)),
);

final deleteDocumentProvider = Provider<DeleteDocument>(
  (ref) => DeleteDocument(ref.watch(documentRepositoryProvider)),
);

// ── State provider (AsyncNotifier) ───────────────────────

class DocumentsNotifier extends AsyncNotifier<List<Document>> {
  @override
  Future<List<Document>> build() async {
    return _load();
  }

  Future<List<Document>> _load() async {
    final result = await ref.read(listDocumentsProvider).call(const NoParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (documents) => documents,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load());
  }

  Future<void> delete(String filename) async {
    // Optimistic removal
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.where((d) => d.filename != filename).toList(),
    );

    final result = await ref
        .read(deleteDocumentProvider)
        .call(filename);

    result.fold(
      (failure) {
        // Restore on failure
        state = AsyncError(failure, StackTrace.current);
        refresh();
      },
      (_) => null, // Already removed optimistically
    );
  }
}

final documentsProvider =
    AsyncNotifierProvider<DocumentsNotifier, List<Document>>(
  DocumentsNotifier.new,
);
