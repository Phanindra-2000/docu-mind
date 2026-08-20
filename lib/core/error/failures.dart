import 'package:equatable/equatable.dart';

/// Sealed failure hierarchy.
///
/// Uses sealed classes for exhaustive pattern matching in the UI layer.
/// Every failure carries a [message] for display and a [code] for analytics.
sealed class Failure extends Equatable {
  final String message;
  final String code;

  const Failure({
    required this.message,
    this.code = 'unknown',
  });

  @override
  List<Object> get props => [message, code];
}

final class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code = 'server_error',
    this.statusCode,
  });

  @override
  List<Object> get props => [message, code, statusCode ?? 0];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'network_error',
  });
}

final class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Local storage error.',
    super.code = 'cache_error',
  });
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Invalid input.',
    super.code = 'validation_error',
  });
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.code = 'not_found',
  });
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Authentication required.',
    super.code = 'unauthorized',
  });
}
