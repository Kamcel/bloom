import 'package:bloom/core/router/routes.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:bloom/features/auth/presentation/widgets/logo_and_tagline.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isChecked = false;
  bool _isSigningUp = false;
  bool _isGoogleLoading = false;

  // Validation booleans
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  // ── Password rule trackers ────────────────────────────────────────────────
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _showPasswordRules = false;

  // ── Visibility toggles ────────────────────────────────────────────────────
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Email ─────────────────────────────────────────────────────────────────

  void _onEmailChanged(String value) {
    setState(() {
      _isEmailValid =
          value.isNotEmpty &&
          RegExp(r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$').hasMatch(value);
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$').hasMatch(value.trim())) {
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
      _showPasswordRules = value.isNotEmpty;

      _isConfirmPasswordValid =
          _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == value;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain an uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain a lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Must contain a number';
    if (!RegExp(r'[!@#`$%^&*()?]').hasMatch(value)) {
      return 'Must contain a special character';
    }
    return null;
  }

  // ── Confirm password ──────────────────────────────────────────────────────

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _isConfirmPasswordValid =
          value.isNotEmpty && value == _passwordController.text;
    });
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
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
    return _isPasswordValid ? Colors.green : colors.error;
  }

  Color _confirmPasswordBorderColor(
    ColorScheme colors, {
    bool focused = false,
  }) {
    if (_confirmPasswordController.text.isEmpty) {
      return focused ? colors.primary : colors.outlineVariant;
    }
    return _isConfirmPasswordValid ? Colors.green : colors.error;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _onSignUpPressed() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms & conditions to continue.'),
        ),
      );
      return;
    }

    setState(() => _isSigningUp = true);
    try {
      // TODO: Connect sign-up logic / auth controller here
    } finally {
      if (mounted) {
        setState(() => _isSigningUp = false);
      }
    }
  }

  Future<void> _onGoogleSignInPressed() async {
    setState(() => _isGoogleLoading = true);
    try {
      // TODO: Connect Google sign-in logic / auth controller here
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _onLoginNavigationPressed() async {
    context.go(Routes.loginScreen);
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.feature),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final anyLoading = _isSigningUp || _isGoogleLoading;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoAndTagline(
                  logoUrl: 'assets/images/bloom_logo.svg',
                  tagline: 'A little more supported, every step of the way',
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
                        textInputAction: TextInputAction.next,
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

                      // Password rules checklist (shown once)
                      if (_showPasswordRules) ...[
                        const SizedBox(height: AppSpacing.standard),
                        _buildPasswordRule(
                          'At least 8 characters',
                          _hasMinLength,
                        ),
                        _buildPasswordRule(
                          'At least one uppercase letter',
                          _hasUpperCase,
                        ),
                        _buildPasswordRule(
                          'At least one lowercase letter',
                          _hasLowerCase,
                        ),
                        _buildPasswordRule('At least one number', _hasNumber),
                        _buildPasswordRule(
                          'At least one special character (!@#^&*?)',
                          _hasSpecialChar,
                        ),
                      ],
                      Gap.vMin,

                      // Confirm Password
                      AuthTextfield(
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword,
                        onChanged: _onConfirmPasswordChanged,
                        obscureText: !_isConfirmPasswordVisible,
                        textInputAction: TextInputAction.done,
                        inputDecoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm Password',
                          prefixIcon: PhosphorIcon(
                            PhosphorIcons.lock,
                            color: colors.primary,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            }),
                            child: PhosphorIcon(
                              _isConfirmPasswordVisible
                                  ? PhosphorIcons.eyeSlash
                                  : PhosphorIcons.eye,
                            ),
                          ),
                          enabledBorder: _border(
                            _confirmPasswordBorderColor(colors),
                          ),
                          focusedBorder: _border(
                            _confirmPasswordBorderColor(colors, focused: true),
                          ),
                          errorBorder: _border(colors.error),
                          focusedErrorBorder: _border(colors.error),
                        ),
                      ),
                    ],
                  ),
                ),

                // Terms checkbox
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('I agree to terms & conditions'),
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),

                Gap.vBreathing,

                // Sign Up button
                AppButton(
                  label: 'Sign Up',
                  isLoading: _isSigningUp,
                  isEnabled: !anyLoading,
                  onPressed: _onSignUpPressed,
                ),

                Gap.vGroup,

                // Continue with Google button
                AppButton(
                  label: 'Continue with Google',
                  isLoading: _isGoogleLoading,
                  isEnabled: !anyLoading,
                  icon: PhosphorIcon(PhosphorIcons.googleLogo),
                  onPressed: _onGoogleSignInPressed,
                ),

                const SizedBox(height: AppSpacing.standard),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: anyLoading ? null : _onLoginNavigationPressed,
                      child: Text(
                        'Log In',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

Widget _buildPasswordRule(String label, bool isSatisfied) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        Icon(
          isSatisfied ? Icons.check_circle : Icons.circle_outlined,
          color: isSatisfied ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isSatisfied ? Colors.green : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
