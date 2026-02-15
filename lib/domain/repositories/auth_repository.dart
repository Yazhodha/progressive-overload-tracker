import '../entities/user.dart';
import '../../core/utils/result.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Get current authenticated user
  User? get currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Sign in with Google
  Future<Result<User>> signInWithGoogle();

  /// Sign in with email and password
  Future<Result<User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Result<User>> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign out
  Future<Result<void>> signOut();

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Update user profile
  Future<Result<User>> updateProfile({
    String? displayName,
    String? avatarUrl,
  });

  /// Delete user account
  Future<Result<void>> deleteAccount();

  /// Refresh current session
  Future<Result<void>> refreshSession();
}
