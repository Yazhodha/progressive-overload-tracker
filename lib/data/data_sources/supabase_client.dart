import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/env_config.dart';

/// Supabase client singleton
class SupabaseClientService {
  SupabaseClientService._();

  static SupabaseClient? _client;
  static bool _isInitialized = false;

  /// Initialize Supabase
  static Future<void> initialize() async {
    if (_isInitialized) return;

    final url = EnvConfig.supabaseUrl;
    final anonKey = EnvConfig.supabaseAnonKey;

    if (url.isEmpty || anonKey.isEmpty) {
      // Supabase not configured - will use mock authentication
      _isInitialized = true;
      return;
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    _client = Supabase.instance.client;
    _isInitialized = true;
  }

  /// Get Supabase client
  static SupabaseClient? get client => _client;

  /// Check if Supabase is available
  static bool get isAvailable => _client != null;

  /// Get auth instance
  static GoTrueClient? get auth => _client?.auth;

  /// Get current user
  static User? get currentUser => _client?.auth.currentUser;

  /// Get current session
  static Session? get currentSession => _client?.auth.currentSession;

  /// Check if user is signed in
  static bool get isSignedIn => currentUser != null;

  /// Listen to auth state changes
  static Stream<AuthState>? get authStateChanges =>
      _client?.auth.onAuthStateChange;

  /// Sign out
  static Future<void> signOut() async {
    await _client?.auth.signOut();
  }
}
