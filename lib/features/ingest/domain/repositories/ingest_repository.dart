import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/utils/file_upload.dart';
import 'package:docu_mind/features/ingest/domain/entities/ingest_result.dart';

/// Abstract repository for PDF ingest operations.
abstract class IngestRepository {
  /// Uploads and ingests a PDF file into the RAG system.
  Future<Either<Failure, IngestResult>> ingestPdf(FileUpload file);
}
