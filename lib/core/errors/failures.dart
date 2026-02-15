import 'package:flutter/foundation.dart';

/// Base class for all failures in the application
@immutable
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Server-related failures
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.statusCode,
  });

  factory ServerFailure.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: message ?? 'Bad request',
          code: 'BAD_REQUEST',
          statusCode: statusCode,
        );
      case 401:
        return ServerFailure(
          message: message ?? 'Unauthorized',
          code: 'UNAUTHORIZED',
          statusCode: statusCode,
        );
      case 403:
        return ServerFailure(
          message: message ?? 'Forbidden',
          code: 'FORBIDDEN',
          statusCode: statusCode,
        );
      case 404:
        return ServerFailure(
          message: message ?? 'Resource not found',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );
      case 409:
        return ServerFailure(
          message: message ?? 'Conflict',
          code: 'CONFLICT',
          statusCode: statusCode,
        );
      case 422:
        return ServerFailure(
          message: message ?? 'Validation failed',
          code: 'VALIDATION_ERROR',
          statusCode: statusCode,
        );
      case 429:
        return ServerFailure(
          message: message ?? 'Too many requests',
          code: 'RATE_LIMITED',
          statusCode: statusCode,
        );
      case 500:
        return ServerFailure(
          message: message ?? 'Internal server error',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );
      case 502:
        return ServerFailure(
          message: message ?? 'Bad gateway',
          code: 'BAD_GATEWAY',
          statusCode: statusCode,
        );
      case 503:
        return ServerFailure(
          message: message ?? 'Service unavailable',
          code: 'SERVICE_UNAVAILABLE',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          message: message ?? 'Unknown server error',
          code: 'UNKNOWN_ERROR',
          statusCode: statusCode,
        );
    }
  }
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code = 'NO_NETWORK',
    super.originalError,
    super.stackTrace,
  });
}

/// Cache/local storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthFailure.invalidCredentials() => const AuthFailure(
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
        message: 'Email is already registered',
        code: 'EMAIL_IN_USE',
      );

  factory AuthFailure.weakPassword() => const AuthFailure(
        message: 'Password is too weak',
        code: 'WEAK_PASSWORD',
      );

  factory AuthFailure.userNotFound() => const AuthFailure(
        message: 'User not found',
        code: 'USER_NOT_FOUND',
      );

  factory AuthFailure.tokenExpired() => const AuthFailure(
        message: 'Session expired. Please sign in again',
        code: 'TOKEN_EXPIRED',
      );

  factory AuthFailure.googleSignInCancelled() => const AuthFailure(
        message: 'Google sign-in was cancelled',
        code: 'GOOGLE_SIGNIN_CANCELLED',
      );

  factory AuthFailure.googleSignInFailed([String? details]) => AuthFailure(
        message: details ?? 'Google sign-in failed',
        code: 'GOOGLE_SIGNIN_FAILED',
      );
}

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });
}

/// Database failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code = 'DATABASE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Sync failures
class SyncFailure extends Failure {
  const SyncFailure({
    required super.message,
    super.code = 'SYNC_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Storage failures (file/image operations)
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// AI service failures
class AIFailure extends Failure {
  const AIFailure({
    required super.message,
    super.code = 'AI_ERROR',
    super.originalError,
    super.stackTrace,
  });

  factory AIFailure.quotaExceeded() => const AIFailure(
        message: 'AI usage limit reached. Try again tomorrow',
        code: 'AI_QUOTA_EXCEEDED',
      );

  factory AIFailure.invalidResponse() => const AIFailure(
        message: 'Failed to parse AI response',
        code: 'AI_INVALID_RESPONSE',
      );
}

/// Unknown/unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code = 'UNEXPECTED_ERROR',
    super.originalError,
    super.stackTrace,
  });
}
