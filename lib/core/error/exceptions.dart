/// Base app exception. Data layer throws these, repository maps to [Failure].
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});
}

final class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

final class CacheException extends AppException {
  const CacheException({required super.message});
}

final class NetworkException extends AppException {
  const NetworkException({required super.message});
}

final class ParseException extends AppException {
  const ParseException({required super.message});
}
