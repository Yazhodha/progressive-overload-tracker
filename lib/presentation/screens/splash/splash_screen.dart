import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

/// Splash screen - shown while checking auth state
/// This is a simple visual placeholder. Navigation is handled by AuthWrapper.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppLogo(size: 120),
      ),
    );
  }
}
