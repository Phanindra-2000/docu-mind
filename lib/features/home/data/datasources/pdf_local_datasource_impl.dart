import 'package:docu_mind/features/home/data/datasources/pdf_local_datasource.dart';
import 'package:docu_mind/features/home/data/models/pdf_document_model.dart';

/// Implementation using shared_preferences or hive.
/// TODO: Replace with actual local storage implementation.
class PdfLocalDataSourceImpl implements PdfLocalDataSource {
  final List<PdfDocumentModel> _cache = [];

  @override
  Future<List<PdfDocumentModel>> getPdfDocuments() async {
    // TODO: Read from actual local storage
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> cachePdfDocuments(List<PdfDocumentModel> documents) async {
    // TODO: Write to actual local storage
    _cache
      ..clear()
      ..addAll(documents);
  }

  @override
  Future<void> deletePdfDocument(String id) async {
    _cache.removeWhere((doc) => doc.id == id);
  }
}
