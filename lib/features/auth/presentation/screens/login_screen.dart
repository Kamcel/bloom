import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:bloom/features/auth/presentation/widgets/logo_and_tagline.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoggingIn = false;
  bool _isGoogleLoading = false;
  bool _isEmailValid = false;
  bool _isPasswordVisible = false;

  // Validation booleans

  bool _isPasswordValid = false;

  // ── Password rule trackers ────────────────────────────────────────────────
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Email ─────────────────────────────────────────────────────────────────

  void _onEmailChanged(String value) {
    setState(() {
      _isEmailValid =
          value.trim().isNotEmpty &&
          RegExp(r'^[\w.-]+@[\w.-]+.[\w.]+$`').hasMatch(value.trim());
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.-]+@[\w.-]+.[\w.]+`$').hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  // ── Password ──────────────────────────────────────────────────────────────

  void _onPasswordChanged(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
      _hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
      _hasNumber = RegExp(r'[0-9]').hasMatch(value);
      _hasSpecialChar = RegExp(r'[!@#$`%^&*()?]').hasMatch(value);
      _isPasswordValid =
          _hasMinLength &&
          _hasUpperCase &&
          _hasLowerCase &&
          _hasNumber &&
          _hasSpecialChar;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  // ── Border colour helpers ─────────────────────────────────────────────────

  Color _emailBorderColor(ColorScheme colors, {bool focused = false}) {
    if (_emailController.text.isEmpty) {
      return focused ? colors.primary : colors.outlineVariant;
    }
    return _isEmailValid ? Colors.green : colors.error;
  }

  Color _passwordBorderColor(ColorScheme colors, {bool focused = false}) {
    if (_passwordController.text.isEmpty) {
      return focused ? colors.primary : colors.outlineVariant;
    }
    return focused ? colors.primary : colors.outlineVariant;
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.feature),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _onLoginPressed() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoggingIn = true);
    try {
      // TODO: Connect email/password login logic here
    } finally {
      if (mounted) {
        setState(() => _isLoggingIn = false);
      }
    }
  }

  Future<void> _onGoogleLoginPressed() async {
    setState(() => _isGoogleLoading = true);
    try {
      // TODO: Connect Google sign-in logic here
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _onForgotPasswordPressed() {
    // TODO: Navigate to forgot password screen or show reset dialog
  }

  void _onSignUpNavigationPressed() {
    // TODO: Navigate to SignUpScreen (e.g. via go_router)
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final anyLoading = _isLoggingIn || _isGoogleLoading;

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
                      // Email
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
                          enabledBorder: _border(_emailBorderColor(colors)),
                          focusedBorder: _border(
                            _emailBorderColor(colors, focused: true),
                          ),
                          errorBorder: _border(colors.error),
                          focusedErrorBorder: _border(colors.error),
                        ),
                      ),
                      Gap.vMin,

                      // Password
                      AuthTextfield(
                        controller: _passwordController,
                        validator: _validatePassword,
                        onChanged: _onPasswordChanged,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        inputDecoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Password',
                          filled: true,
                          fillColor: colors.surface,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            }),
                            child: PhosphorIcon(
                              _isPasswordVisible
                                  ? PhosphorIcons.eyeSlash
                                  : PhosphorIcons.eye,
                            ),
                          ),
                          enabledBorder: _border(_passwordBorderColor(colors)),
                          focusedBorder: _border(
                            _passwordBorderColor(colors, focused: true),
                          ),
                          errorBorder: _border(colors.error),
                          focusedErrorBorder: _border(colors.error),
                        ),
                      ),
                    ],
                  ),
                ),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: anyLoading ? null : _onForgotPasswordPressed,
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

                // Log In button
                AppButton(
                  label: 'Log In',
                  isLoading: _isLoggingIn,
                  isEnabled: !anyLoading,
                  onPressed: _onLoginPressed,
                ),

                Gap.vMin,

                // Continue with Google button
                AppButton(
                  label: 'Continue with Google',
                  isLoading: _isGoogleLoading,
                  isEnabled: !anyLoading,
                  icon: PhosphorIcon(PhosphorIcons.googleLogo),
                  onPressed: _onGoogleLoginPressed,
                ),

                const SizedBox(height: AppSpacing.standard),

                // Switch to Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: anyLoading ? null : _onSignUpNavigationPressed,
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
