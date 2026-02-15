import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication state
sealed class AuthState {
  const AuthState();
}

/// Initial state - checking auth status
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state - auth operation in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state - user is signed in
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

/// Unauthenticated state - no user signed in
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state - auth operation failed
class AuthError extends AuthState {
  final Failure failure;
  const AuthError(this.failure);
}

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = AuthRepositoryImpl();
  ref.onDispose(() {
    repository.dispose();
  });
  return repository;
});

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthInitial()) {
    _init();
  }

  void _init() {
    // Check current auth state
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      state = AuthAuthenticated(currentUser);
    } else {
      state = const AuthUnauthenticated();
    }

    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    });
  }

  /// Sign in with Google
  Future<Result<User>> signInWithGoogle() async {
    state = const AuthLoading();
    final result = await _authRepository.signInWithGoogle();

    result.fold(
      onSuccess: (user) => state = AuthAuthenticated(user),
      onFailure: (failure) => state = AuthError(failure),
    );

    return result;
  }

  /// Sign in with email and password
  Future<Result<User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    final result = await _authRepository.signInWithEmailPassword(
      email: email,
      password: password,
    );

    result.fold(
      onSuccess: (user) => state = AuthAuthenticated(user),
      onFailure: (failure) => state = AuthError(failure),
    );

    return result;
  }

  /// Sign up with email and password
  Future<Result<User>> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthLoading();
    final result = await _authRepository.signUpWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    result.fold(
      onSuccess: (user) => state = AuthAuthenticated(user),
      onFailure: (failure) => state = AuthError(failure),
    );

    return result;
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    state = const AuthLoading();
    final result = await _authRepository.signOut();

    result.fold(
      onSuccess: (_) => state = const AuthUnauthenticated(),
      onFailure: (failure) => state = AuthError(failure),
    );

    return result;
  }

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    return _authRepository.sendPasswordResetEmail(email);
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }
}

/// Auth state notifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

/// Current user provider (convenience provider)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return switch (authState) {
    AuthAuthenticated(:final user) => user,
    _ => null,
  };
});

/// Is authenticated provider (convenience provider)
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthAuthenticated;
});

/// Is loading provider (convenience provider)
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthLoading;
});
