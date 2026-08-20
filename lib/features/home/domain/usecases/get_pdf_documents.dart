import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/usecase/usecase.dart';
import 'package:docu_mind/features/home/domain/entities/pdf_document.dart';
import 'package:docu_mind/features/home/domain/repositories/pdf_repository.dart';

/// Use case: retrieve all PDF documents.
class GetPdfDocuments extends UseCase<List<PdfDocument>, NoParams> {
  final PdfRepository repository;

  const GetPdfDocuments(this.repository);

  @override
  Future<Either<Failure, List<PdfDocument>>> call(NoParams params) {
    return repository.getPdfDocuments();
  }
}
