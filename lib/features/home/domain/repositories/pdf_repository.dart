import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/features/home/domain/entities/pdf_document.dart';

/// Abstract repository contract — defined in domain, implemented in data.
abstract class PdfRepository {
  /// Returns a list of all locally stored PDF documents.
  Future<Either<Failure, List<PdfDocument>>> getPdfDocuments();

  /// Saves a PDF document and returns the created entity.
  Future<Either<Failure, PdfDocument>> savePdfDocument(PdfDocument document);

  /// Deletes a PDF document by its id.
  Future<Either<Failure, void>> deletePdfDocument(String id);
}
