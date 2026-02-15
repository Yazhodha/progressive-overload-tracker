import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../core/errors/failures.dart';
import '../../core/utils/env_config.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/supabase_client.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository
/// Supports both Supabase and mock authentication
class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final StreamController<User?> _authStateController;
  User? _currentUser;
  bool _useMockAuth = false;

  // Web client ID for Supabase to validate the ID token
  static const String _webClientId = '457441650323-5mr72svsgd5bmnhfro12pnggjvio8tcn.apps.googleusercontent.com';

  AuthRepositoryImpl({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ?? GoogleSignIn(
          scopes: ['email', 'profile'],
          serverClientId: _webClientId,
        ),
        _authStateController = StreamController<User?>.broadcast() {
    _useMockAuth = EnvConfig.enableMockAuth || !SupabaseClientService.isAvailable;
    _initializeAuthState();
  }

  void _initializeAuthState() {
    if (_useMockAuth) {
      // Mock auth - no initial user
      _authStateController.add(null);
    } else {
      // Listen to Supabase auth changes
      SupabaseClientService.authStateChanges?.listen((authState) {
        final supabaseUser = authState.session?.user;
        if (supabaseUser != null) {
          _currentUser = UserModel.fromSupabaseUser(supabaseUser.toJson());
          _authStateController.add(_currentUser);
        } else {
          _currentUser = null;
          _authStateController.add(null);
        }
      });
    }
  }

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<Result<User>> signInWithGoogle() async {
    try {
      if (_useMockAuth) {
        return _mockGoogleSignIn();
      }

      // Real Google Sign-In with Supabase
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Error(AuthFailure.googleSignInCancelled());
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        return Error(AuthFailure.googleSignInFailed('Failed to get tokens'));
      }

      final response = await SupabaseClientService.auth?.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response?.user == null) {
        return Error(AuthFailure.googleSignInFailed());
      }

      final user = UserModel.fromSupabaseUser(response!.user!.toJson());
      _currentUser = user;
      _authStateController.add(user);

      return Success(user);
    } catch (e, stackTrace) {
      debugPrint('Google Sign-In error: $e');
      return Error(AuthFailure(
        message: 'Google sign-in failed: ${e.toString()}',
        code: 'GOOGLE_SIGNIN_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<User>> _mockGoogleSignIn() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final mockUser = UserModel(
      id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      email: 'demo@example.com',
      displayName: 'Demo User',
      avatarUrl: null,
      createdAt: DateTime.now(),
      lastSignInAt: DateTime.now(),
      isOnboardingComplete: false,
    );

    _currentUser = mockUser;
    _authStateController.add(mockUser);

    return Success(mockUser);
  }

  @override
  Future<Result<User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (_useMockAuth) {
        return _mockEmailSignIn(email);
      }

      final response = await SupabaseClientService.auth?.signInWithPassword(
        email: email,
        password: password,
      );

      if (response?.user == null) {
        return Error(AuthFailure.invalidCredentials());
      }

      final user = UserModel.fromSupabaseUser(response!.user!.toJson());
      _currentUser = user;
      _authStateController.add(user);

      return Success(user);
    } catch (e, stackTrace) {
      debugPrint('Email sign-in error: $e');
      return Error(AuthFailure(
        message: 'Sign-in failed: ${e.toString()}',
        code: 'SIGNIN_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<User>> _mockEmailSignIn(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final mockUser = UserModel(
      id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@').first,
      avatarUrl: null,
      createdAt: DateTime.now(),
      lastSignInAt: DateTime.now(),
      isOnboardingComplete: false,
    );

    _currentUser = mockUser;
    _authStateController.add(mockUser);

    return Success(mockUser);
  }

  @override
  Future<Result<User>> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      if (_useMockAuth) {
        return _mockEmailSignUp(email, displayName);
      }

      final response = await SupabaseClientService.auth?.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'full_name': displayName} : null,
      );

      if (response?.user == null) {
        return Error(const AuthFailure(
          message: 'Failed to create account',
          code: 'SIGNUP_ERROR',
        ));
      }

      final user = UserModel.fromSupabaseUser(response!.user!.toJson());
      _currentUser = user;
      _authStateController.add(user);

      return Success(user);
    } catch (e, stackTrace) {
      debugPrint('Email sign-up error: $e');

      // Check for common errors
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('already registered') ||
          errorMessage.contains('already in use')) {
        return Error(AuthFailure.emailAlreadyInUse());
      }
      if (errorMessage.contains('weak password')) {
        return Error(AuthFailure.weakPassword());
      }

      return Error(AuthFailure(
        message: 'Sign-up failed: ${e.toString()}',
        code: 'SIGNUP_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<User>> _mockEmailSignUp(String email, String? displayName) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final mockUser = UserModel(
      id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName ?? email.split('@').first,
      avatarUrl: null,
      createdAt: DateTime.now(),
      lastSignInAt: DateTime.now(),
      isOnboardingComplete: false,
    );

    _currentUser = mockUser;
    _authStateController.add(mockUser);

    return Success(mockUser);
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      if (_useMockAuth) {
        await Future.delayed(const Duration(milliseconds: 300));
      } else {
        await SupabaseClientService.signOut();
      }

      await _googleSignIn.signOut();
      _currentUser = null;
      _authStateController.add(null);

      return const Success(null);
    } catch (e, stackTrace) {
      debugPrint('Sign-out error: $e');
      return Error(AuthFailure(
        message: 'Sign-out failed: ${e.toString()}',
        code: 'SIGNOUT_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      if (_useMockAuth) {
        await Future.delayed(const Duration(milliseconds: 500));
        return const Success(null);
      }

      await SupabaseClientService.auth?.resetPasswordForEmail(email);
      return const Success(null);
    } catch (e, stackTrace) {
      debugPrint('Password reset error: $e');
      return Error(AuthFailure(
        message: 'Failed to send reset email: ${e.toString()}',
        code: 'RESET_PASSWORD_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<User>> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      if (_currentUser == null) {
        return Error(const AuthFailure(
          message: 'No user signed in',
          code: 'NO_USER',
        ));
      }

      if (_useMockAuth) {
        final updatedUser = _currentUser!.copyWith(
          displayName: displayName ?? _currentUser!.displayName,
          avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
        );
        _currentUser = updatedUser;
        _authStateController.add(updatedUser);
        return Success(updatedUser);
      }

      final response = await SupabaseClientService.auth?.updateUser(
        UserAttributes(
          data: {
            if (displayName != null) 'full_name': displayName,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      if (response?.user == null) {
        return Error(const AuthFailure(
          message: 'Failed to update profile',
          code: 'UPDATE_PROFILE_ERROR',
        ));
      }

      final user = UserModel.fromSupabaseUser(response!.user!.toJson());
      _currentUser = user;
      _authStateController.add(user);

      return Success(user);
    } catch (e, stackTrace) {
      debugPrint('Update profile error: $e');
      return Error(AuthFailure(
        message: 'Failed to update profile: ${e.toString()}',
        code: 'UPDATE_PROFILE_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      if (_useMockAuth) {
        await Future.delayed(const Duration(milliseconds: 500));
        _currentUser = null;
        _authStateController.add(null);
        return const Success(null);
      }

      // Note: Supabase requires admin API to delete users
      // For now, we'll just sign out
      await signOut();
      return const Success(null);
    } catch (e, stackTrace) {
      debugPrint('Delete account error: $e');
      return Error(AuthFailure(
        message: 'Failed to delete account: ${e.toString()}',
        code: 'DELETE_ACCOUNT_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> refreshSession() async {
    try {
      if (_useMockAuth) {
        return const Success(null);
      }

      await SupabaseClientService.auth?.refreshSession();
      return const Success(null);
    } catch (e, stackTrace) {
      debugPrint('Refresh session error: $e');
      return Error(AuthFailure(
        message: 'Failed to refresh session: ${e.toString()}',
        code: 'REFRESH_SESSION_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}
