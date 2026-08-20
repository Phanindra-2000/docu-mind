import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/usecase/usecase.dart';
import 'package:docu_mind/features/documents/domain/repositories/document_repository.dart';

/// Use case: delete a document by filename.
class DeleteDocument extends UseCase<void, String> {
  final DocumentRepository repository;

  const DeleteDocument(this.repository);

  @override
  Future<Either<Failure, void>> call(String filename) {
    return repository.deleteDocument(filename);
  }
}
