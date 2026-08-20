import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/usecase/usecase.dart';
import 'package:docu_mind/core/utils/file_upload.dart';
import 'package:docu_mind/features/ingest/domain/entities/ingest_result.dart';
import 'package:docu_mind/features/ingest/domain/repositories/ingest_repository.dart';

/// Use case: upload and ingest a PDF file.
class IngestPdf extends UseCase<IngestResult, FileUpload> {
  final IngestRepository repository;

  const IngestPdf(this.repository);

  @override
  Future<Either<Failure, IngestResult>> call(FileUpload params) {
    return repository.ingestPdf(params);
  }
}
