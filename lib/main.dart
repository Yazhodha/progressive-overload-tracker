import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/env_config.dart';
import 'data/data_sources/supabase_client.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize environment variables
  try {
    await EnvConfig.init();
  } catch (e) {
    debugPrint('Warning: Failed to load .env file: $e');
    // Continue anyway - we'll use mock auth if no env is configured
  }

  // Initialize Supabase (if configured)
  try {
    await SupabaseClientService.initialize();
  } catch (e) {
    debugPrint('Warning: Failed to initialize Supabase: $e');
    // Continue anyway - we'll use mock auth
  }

  runApp(
    const ProviderScope(
      child: ProgressiveOverloadApp(),
    ),
  );
}

/// Main application widget
class ProgressiveOverloadApp extends ConsumerWidget {
  const ProgressiveOverloadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Progressive Overload Tracker',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Initial route with auth-aware navigation
      home: const AuthWrapper(),
    );
  }
}

/// Auth wrapper that redirects based on auth state
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return switch (authState) {
      AuthInitial() => const SplashScreen(),
      AuthLoading() => const SplashScreen(),
      AuthAuthenticated() => const HomeScreen(),
      AuthUnauthenticated() => const SignInScreen(),
      AuthError() => const SignInScreen(),
    };
  }
}
