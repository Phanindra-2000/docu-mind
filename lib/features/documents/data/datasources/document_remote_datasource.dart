import 'package:docu_mind/features/documents/data/models/document_model.dart';

/// Abstract remote data source for document API calls.
abstract class DocumentRemoteDataSource {
  /// GET /documents
  Future<List<DocumentModel>> listDocuments();

  /// DELETE /documents/{filename}
  Future<void> deleteDocument(String filename);
}
