import 'package:equatable/equatable.dart';


abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}


class OutOfBoundsFailure extends Failure {
  const OutOfBoundsFailure({super.message = 'Requested slot or span exceeds day boundary'});
}

class OverlapFailure extends Failure {
  const OverlapFailure({
    super.message = 'Selected range overlaps with an existing booking or break',
    this.conflictingIndex,
  });

  final int? conflictingIndex;

  @override
  List<Object?> get props => [message, conflictingIndex];
}

class IsolatedGapFailure extends Failure {
  const IsolatedGapFailure({
    super.message = 'Booking creates an isolated 30-minute orphaned slot',
    this.gapIndex,
  });

  final int? gapIndex;

  @override
  List<Object?> get props => [message, gapIndex];
}

class InvalidStartFailure extends Failure {
  const InvalidStartFailure({
    super.message = 'Selected start slot is not available',
    this.startIndex,
  });

  final int? startIndex;

  @override
  List<Object?> get props => [message, startIndex];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
