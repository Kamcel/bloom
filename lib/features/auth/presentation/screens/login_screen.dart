
import 'package:bloom/core/router/routes.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/auth/data/models/auth_state.dart';
import 'package:bloom/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bloom/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:bloom/features/auth/presentation/widgets/logo_and_tagline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isEmailValid = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // EMAIL

  void _onEmailChanged(String value) {
    setState(() {
      _isEmailValid =
          value.trim().isNotEmpty &&
          RegExp(r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$')
              .hasMatch(value.trim());
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$')
        .hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  // PASSWORD

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  // BORDER HELPERS

  Color _emailBorderColor(
    ColorScheme colors, {
    bool focused = false,
  }) {
    if (_emailController.text.isEmpty) {
      return focused ? colors.primary : colors.outlineVariant;
    }

    return _isEmailValid ? Colors.green : colors.error;
  }

  Color _passwordBorderColor(
    ColorScheme colors, {
    bool focused = false,
  }) {
    if (_passwordController.text.isEmpty) {
      return focused ? colors.primary : colors.outlineVariant;
    }

    return colors.primary;
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.feature),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  // AUTHENTICATION

  Future<void> _onLoginPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref.read(authControllerProvider.notifier).signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _onGoogleLoginPressed() async {
    await ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle();
  }

  // NAVIGATION

  void _onForgotPasswordPressed() {
    context.push(Routes.forgotPasswordScreen);
  }

  void _onSignUpNavigationPressed() {
    context.go(Routes.signUpScreen);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Listen for authentication feedback.
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        emailVerificationPending: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        authError: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: colors.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    // Read the current authentication state.
    final authState = ref.watch(authControllerProvider);

    final isLoading = authState.maybeWhen(
      authLoading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.breathing * 2,
              horizontal: AppSpacing.standard,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoAndTagline(
                  logoUrl: 'assets/images/bloom_logo.svg',
                  tagline:
                      'Welcome back, let us take it one gentle step at a time',
                ),

                const SizedBox(height: AppSpacing.breathing),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // EMAIL
                      AuthTextfield(
                        controller: _emailController,
                        validator: _validateEmail,
                        onChanged: _onEmailChanged,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        inputDecoration: InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'Email',
                          prefixIcon: PhosphorIcon(
                            PhosphorIcons.envelope,
                            color: colors.primary,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          enabledBorder: _border(
                            _emailBorderColor(colors),
                          ),
                          focusedBorder: _border(
                            _emailBorderColor(
                              colors,
                              focused: true,
                            ),
                          ),
                          errorBorder: _border(colors.error),
                          focusedErrorBorder: _border(colors.error),
                        ),
                      ),

                      Gap.vMin,

                      // PASSWORD
                      AuthTextfield(
                        controller: _passwordController,
                        validator: _validatePassword,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        inputDecoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Password',
                          prefixIcon: PhosphorIcon(
                            PhosphorIcons.lock,
                            color: colors.primary,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible;
                              });
                            },
                            child: PhosphorIcon(
                              _isPasswordVisible
                                  ? PhosphorIcons.eyeSlash
                                  : PhosphorIcons.eye,
                            ),
                          ),
                          enabledBorder: _border(
                            _passwordBorderColor(colors),
                          ),
                          focusedBorder: _border(
                            _passwordBorderColor(
                              colors,
                              focused: true,
                            ),
                          ),
                          errorBorder: _border(colors.error),
                          focusedErrorBorder: _border(colors.error),
                        ),
                      ),
                    ],
                  ),
                ),

                // FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        isLoading ? null : _onForgotPasswordPressed,
                    child: Text(
                      'Forgot password?',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Gap.vMin,

                // LOG IN
                AppButton(
                  label: 'Log In',
                  isLoading: isLoading,
                  isEnabled: !isLoading,
                  onPressed: _onLoginPressed,
                ),

                Gap.vMin,

                // GOOGLE SIGN IN
                AppButton(
                  label: 'Continue with Google',
                  isLoading: isLoading,
                  isEnabled: !isLoading,
                  icon: PhosphorIcon(
                    PhosphorIcons.googleLogo,
                  ),
                  onPressed: _onGoogleLoginPressed,
                ),

                const SizedBox(height: AppSpacing.standard),

                // SIGN UP NAVIGATION
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : _onSignUpNavigationPressed,
                      child: Text(
                        'Sign Up',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
