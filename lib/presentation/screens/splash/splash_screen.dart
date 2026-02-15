import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/widgets.dart';
import '../auth/sign_in_screen.dart';
import '../home/home_screen.dart';

/// Splash screen - shown while checking auth state
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Wait a bit to show the splash screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);
    _navigateBasedOnAuthState(authState);
  }

  void _navigateBasedOnAuthState(AuthState authState) {
    Widget destination;

    switch (authState) {
      case AuthAuthenticated():
        destination = const HomeScreen();
      case AuthUnauthenticated():
      case AuthError():
      case AuthInitial():
      case AuthLoading():
        destination = const SignInScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (previous is AuthInitial && next is! AuthInitial) {
        _navigateBasedOnAuthState(next);
      }
    });

    return const Scaffold(
      body: Center(
        child: AppLogo(size: 120),
      ),
    );
  }
}
