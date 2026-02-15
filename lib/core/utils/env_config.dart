import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration helper
class EnvConfig {
  EnvConfig._();

  /// Initialize environment variables
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  /// Get environment variable or throw if not found
  static String get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('Environment variable $key is not set');
    }
    return value;
  }

  /// Get environment variable or return default value
  static String getOrDefault(String key, String defaultValue) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      return defaultValue;
    }
    return value;
  }

  /// Check if environment variable exists
  static bool has(String key) {
    final value = dotenv.env[key];
    return value != null && value.isNotEmpty;
  }

  // Supabase Configuration
  static String get supabaseUrl => getOrDefault('SUPABASE_URL', '');
  static String get supabaseAnonKey => getOrDefault('SUPABASE_ANON_KEY', '');

  // DeepSeek AI Configuration
  static String get deepSeekApiKey => getOrDefault('DEEPSEEK_API_KEY', '');

  // Feature Flags
  static bool get isDebugMode =>
      getOrDefault('DEBUG_MODE', 'false').toLowerCase() == 'true';
  static bool get enableMockAuth =>
      getOrDefault('ENABLE_MOCK_AUTH', 'true').toLowerCase() == 'true';
  static bool get enableAIFeatures =>
      getOrDefault('ENABLE_AI_FEATURES', 'true').toLowerCase() == 'true';

  // Check if Supabase is configured
  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // Check if AI is configured
  static bool get isAIConfigured => deepSeekApiKey.isNotEmpty;
}
