import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/exceptions.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/features/documents/data/datasources/document_remote_datasource.dart';
import 'package:docu_mind/features/documents/domain/entities/document.dart';
import 'package:docu_mind/features/documents/domain/repositories/document_repository.dart';

/// Concrete implementation of [DocumentRepository].
class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource remoteDataSource;

  const DocumentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Document>>> listDocuments() async {
    try {
      final models = await remoteDataSource.listDocuments();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String filename) async {
    try {
      await remoteDataSource.deleteDocument(filename);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
