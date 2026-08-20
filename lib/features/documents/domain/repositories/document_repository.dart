import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/features/documents/domain/entities/document.dart';

/// Abstract repository for document operations.
abstract class DocumentRepository {
  /// Returns all documents stored on the server.
  Future<Either<Failure, List<Document>>> listDocuments();

  /// Deletes a document by its filename.
  Future<Either<Failure, void>> deleteDocument(String filename);
}
