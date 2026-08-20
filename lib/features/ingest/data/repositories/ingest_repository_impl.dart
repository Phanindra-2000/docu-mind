import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/exceptions.dart';
import 'package:docu_mind/core/error/failures.dart';
import 'package:docu_mind/core/utils/file_upload.dart';
import 'package:docu_mind/features/ingest/data/datasources/ingest_remote_datasource.dart';
import 'package:docu_mind/features/ingest/domain/entities/ingest_result.dart';
import 'package:docu_mind/features/ingest/domain/repositories/ingest_repository.dart';

/// Concrete implementation of [IngestRepository].
class IngestRepositoryImpl implements IngestRepository {
  final IngestRemoteDataSource remoteDataSource;

  const IngestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, IngestResult>> ingestPdf(FileUpload file) async {
    try {
      final model = await remoteDataSource.ingestPdf(file);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
