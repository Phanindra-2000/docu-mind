import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/core/providers.dart';
import 'package:docu_mind/core/utils/file_upload.dart';
import 'package:docu_mind/features/ingest/data/datasources/ingest_remote_datasource_impl.dart';
import 'package:docu_mind/features/ingest/data/repositories/ingest_repository_impl.dart';
import 'package:docu_mind/features/ingest/domain/entities/ingest_result.dart';
import 'package:docu_mind/features/ingest/domain/usecases/ingest_pdf.dart';

// ── Data layer providers ─────────────────────────────────

final ingestRemoteDataSourceProvider = Provider<IngestRemoteDataSourceImpl>(
  (ref) => IngestRemoteDataSourceImpl(dio: ref.watch(dioProvider)),
);

final ingestRepositoryProvider = Provider<IngestRepositoryImpl>(
  (ref) => IngestRepositoryImpl(
    remoteDataSource: ref.watch(ingestRemoteDataSourceProvider),
  ),
);

// ── Use case providers ───────────────────────────────────

final ingestPdfUseCaseProvider = Provider<IngestPdf>(
  (ref) => IngestPdf(ref.watch(ingestRepositoryProvider)),
);

// ── State (AsyncNotifier) ────────────────────────────────

/// Manages PDF upload and ingest state.
class IngestNotifier extends AsyncNotifier<IngestResult?> {
  @override
  Future<IngestResult?> build() async => null;

  Future<void> ingest(FileUpload file) async {
    state = const AsyncValue.loading();
    final result = await ref.read(ingestPdfUseCaseProvider).call(file);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (ingestResult) => AsyncData(ingestResult),
    );
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final ingestProvider = AsyncNotifierProvider<IngestNotifier, IngestResult?>(
  IngestNotifier.new,
);
