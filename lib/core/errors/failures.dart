import 'package:equatable/equatable.dart';


abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}


class OutOfBoundsFailure extends Failure {
  const OutOfBoundsFailure({required super.message});
}

class OverlapFailure extends Failure {
  const OverlapFailure({
    required super.message,
    this.conflictingIndex,
  });

  final int? conflictingIndex;

  @override
  List<Object?> get props => [message, conflictingIndex];
}

class IsolatedGapFailure extends Failure {
  const IsolatedGapFailure({
    required super.message,
    this.gapIndex,
  });

  final int? gapIndex;

  @override
  List<Object?> get props => [message, gapIndex];
}

class InvalidStartFailure extends Failure {
  const InvalidStartFailure({
    required super.message,
    this.startIndex,
  });

  final int? startIndex;

  @override
  List<Object?> get props => [message, startIndex];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
