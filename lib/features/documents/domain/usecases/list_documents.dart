import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/usecase/usecase.dart';
import 'package:docu_mind/features/documents/domain/entities/document.dart';
import 'package:docu_mind/features/documents/domain/repositories/document_repository.dart';

/// Use case: list all documents from the server.
class ListDocuments extends UseCase<List<Document>, NoParams> {
  final DocumentRepository repository;

  const ListDocuments(this.repository);

  @override
  Future<Either<Failure, List<Document>>> call(NoParams params) {
    return repository.listDocuments();
  }
}
