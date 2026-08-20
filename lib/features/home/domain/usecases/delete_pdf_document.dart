import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/usecase/usecase.dart';
import 'package:docu_mind/features/home/domain/repositories/pdf_repository.dart';

/// Use case: delete a PDF document by id.
class DeletePdfDocument extends UseCase<void, String> {
  final PdfRepository repository;

  const DeletePdfDocument(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deletePdfDocument(id);
  }
}
