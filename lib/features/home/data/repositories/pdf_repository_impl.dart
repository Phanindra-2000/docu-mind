import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/exceptions.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/features/home/data/datasources/pdf_local_datasource.dart';
import 'package:docu_mind/features/home/data/models/pdf_document_model.dart';
import 'package:docu_mind/features/home/domain/entities/pdf_document.dart';
import 'package:docu_mind/features/home/domain/repositories/pdf_repository.dart';

/// Concrete implementation of [PdfRepository].
///
/// Coordinates between data sources and maps exceptions to [Failure]s.
class PdfRepositoryImpl implements PdfRepository {
  final PdfLocalDataSource localDataSource;

  const PdfRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PdfDocument>>> getPdfDocuments() async {
    try {
      final documents = await localDataSource.getPdfDocuments();
      return Right(documents);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PdfDocument>> savePdfDocument(
    PdfDocument document,
  ) async {
    try {
      final model = PdfDocumentModel(
        id: document.id,
        name: document.name,
        path: document.path,
        size: document.size,
        createdAt: document.createdAt,
      );
      final existing = await localDataSource.getPdfDocuments();
      final updated = [...existing, model];
      await localDataSource.cachePdfDocuments(updated);
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deletePdfDocument(String id) async {
    try {
      await localDataSource.deletePdfDocument(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
