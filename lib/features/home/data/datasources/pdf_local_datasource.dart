import 'package:docu_mind/features/home/data/models/pdf_document_model.dart';

/// Abstract local data source contract.
abstract class PdfLocalDataSource {
  /// Returns cached list of PDF documents.
  Future<List<PdfDocumentModel>> getPdfDocuments();

  /// Caches a list of PDF documents.
  Future<void> cachePdfDocuments(List<PdfDocumentModel> documents);

  /// Deletes a document from cache.
  Future<void> deletePdfDocument(String id);
}
