import 'package:dartz/dartz.dart';
import 'package:docu_mind/core/error/failures.dart';

/// Base use case contract.
///
/// [Type] is the return type on success.
/// [Params] is the parameter type passed to the use case.
abstract class UseCase<T, Params> {
  const UseCase();

  Future<Either<Failure, T>> call(Params params);
}

/// Use this when a use case takes no parameters.
class NoParams {
  const NoParams();
}
