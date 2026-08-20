import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/features/home/data/datasources/pdf_local_datasource_impl.dart';
import 'package:docu_mind/features/home/data/repositories/pdf_repository_impl.dart';
import 'package:docu_mind/features/home/domain/entities/pdf_document.dart';
import 'package:docu_mind/features/home/domain/usecases/get_pdf_documents.dart';
import 'package:docu_mind/core/usecase/usecase.dart';

// ── Data layer providers ─────────────────────────────────

final pdfLocalDataSourceProvider = Provider<PdfLocalDataSourceImpl>(
  (ref) => PdfLocalDataSourceImpl(),
);

final pdfRepositoryProvider = Provider<PdfRepositoryImpl>(
  (ref) => PdfRepositoryImpl(
    localDataSource: ref.watch(pdfLocalDataSourceProvider),
  ),
);

// ── Use case providers ───────────────────────────────────

final getPdfDocumentsProvider = Provider<GetPdfDocuments>(
  (ref) => GetPdfDocuments(ref.watch(pdfRepositoryProvider)),
);

// ── State (AsyncNotifier) ────────────────────────────────

/// Manages local PDF documents list.
class HomeNotifier extends AsyncNotifier<List<PdfDocument>> {
  @override
  Future<List<PdfDocument>> build() async {
    final result = await ref
        .read(getPdfDocumentsProvider)
        .call(const NoParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (documents) => documents,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}

final homeProvider = AsyncNotifierProvider<HomeNotifier, List<PdfDocument>>(
  HomeNotifier.new,
);
