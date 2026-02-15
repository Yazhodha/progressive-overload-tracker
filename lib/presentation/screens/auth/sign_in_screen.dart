import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/widgets.dart';
import 'sign_up_screen.dart';

/// Sign in screen
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isGoogleLoading = false;
  bool _isEmailLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    final result = await ref.read(authNotifierProvider.notifier).signInWithGoogle();

    if (!mounted) return;

    setState(() => _isGoogleLoading = false);

    result.onFailure((failure) {
      context.showSnackBar(failure.message, isError: true);
    });
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isEmailLoading = true);

    final result = await ref.read(authNotifierProvider.notifier).signInWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    setState(() => _isEmailLoading = false);

    result.onFailure((failure) {
      context.showSnackBar(failure.message, isError: true);
    });
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailController,
              hint: 'Email address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty) return;

              Navigator.pop(context);

              final result = await ref
                  .read(authNotifierProvider.notifier)
                  .sendPasswordResetEmail(emailController.text.trim());

              if (!mounted) return;

              result.fold(
                onSuccess: (_) {
                  context.showSuccessSnackBar('Password reset email sent');
                },
                onFailure: (failure) {
                  context.showSnackBar(failure.message, isError: true);
                },
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isGoogleLoading || _isEmailLoading;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 1),

                      // Logo
                      const AppLogo(size: 72),

                      const SizedBox(height: 16),

                      // Welcome text
                      Text(
                        'Welcome Back',
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to continue tracking your progress',
                        style: context.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Google sign in button
                      SocialSignInButton.google(
                        onPressed: isLoading ? null : _signInWithGoogle,
                        isLoading: _isGoogleLoading,
                      ),

                      const SizedBox(height: 12),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or continue with email',
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Email form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icons.email_outlined,
                              validator: Validators.validateEmail,
                              enabled: !isLoading,
                            ),
                            const SizedBox(height: 10),
                            AppTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Enter your password',
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icons.lock_outlined,
                              validator: (value) => Validators.validateRequired(value, fieldName: 'Password'),
                              onSubmitted: (_) => _signInWithEmail(),
                              enabled: !isLoading,
                            ),
                          ],
                        ),
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading ? null : _showForgotPasswordDialog,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Forgot Password?'),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Sign in button
                      LoadingButton(
                        text: 'Sign In',
                        onPressed: isLoading ? null : _signInWithEmail,
                        isLoading: _isEmailLoading,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 8),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: context.textTheme.bodySmall,
                          ),
                          TextButton(
                            onPressed: isLoading ? null : _navigateToSignUp,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),

                      const Spacer(flex: 1),

                      // Demo mode indicator
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.infoBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Demo mode: Sign in works without real credentials',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
