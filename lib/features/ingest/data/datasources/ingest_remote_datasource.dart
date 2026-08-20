import 'package:docu_mind/core/utils/file_upload.dart';
import 'package:docu_mind/features/ingest/data/models/ingest_result_model.dart';

/// Abstract remote data source for PDF ingest API calls.
abstract class IngestRemoteDataSource {
  /// POST /ingest — uploads a PDF file for RAG processing.
  Future<IngestResultModel> ingestPdf(FileUpload file);
}
