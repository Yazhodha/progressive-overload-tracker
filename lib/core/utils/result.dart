import '../errors/failures.dart';

/// A Result type that represents either a success or a failure
/// Based on Either pattern for functional error handling
sealed class Result<T> {
  const Result();

  /// Returns true if this is a Success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a Failure
  bool get isFailure => this is Error<T>;

  /// Get the value if Success, or null if Failure
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Error<T>() => null,
      };

  /// Get the failure if Error, or null if Success
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Error<T>(:final failure) => failure,
      };

  /// Map the success value to a new type
  Result<R> map<R>(R Function(T value) mapper) => switch (this) {
        Success<T>(:final value) => Success(mapper(value)),
        Error<T>(:final failure) => Error(failure),
      };

  /// FlatMap the success value to a new Result
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) => switch (this) {
        Success<T>(:final value) => mapper(value),
        Error<T>(:final failure) => Error(failure),
      };

  /// Handle both success and failure cases
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success<T>(:final value) => onSuccess(value),
        Error<T>(:final failure) => onFailure(failure),
      };

  /// Execute action on success
  Result<T> onSuccess(void Function(T value) action) {
    if (this is Success<T>) {
      action((this as Success<T>).value);
    }
    return this;
  }

  /// Execute action on failure
  Result<T> onFailure(void Function(Failure failure) action) {
    if (this is Error<T>) {
      action((this as Error<T>).failure);
    }
    return this;
  }

  /// Get value or throw
  T getOrThrow() => switch (this) {
        Success<T>(:final value) => value,
        Error<T>(:final failure) => throw Exception(failure.message),
      };

  /// Get value or default
  T getOrElse(T defaultValue) => switch (this) {
        Success<T>(:final value) => value,
        Error<T>() => defaultValue,
      };
}

/// Represents a successful result
final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed result
final class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);

  @override
  String toString() => 'Error($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
