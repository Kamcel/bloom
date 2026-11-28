import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:bloom/features/auth/presentation/widgets/logo_and_tagline.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isUpdating = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _showPasswordRules = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Password
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
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain a number';
    }

    if (!RegExp(r'[!@#`$%^&*()?]').hasMatch(value)) {
      return 'Must contain a special character';
    }

    return null;
  }

  // Confirm password
  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _isConfirmPasswordValid =
          value.isNotEmpty && value == _passwordController.text;
    });
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Border helpers
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

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.feature),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  // Action
  Future<void> _onUpdatePasswordPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isUpdating = true);

    try {
      // TODO: Connect AuthController.updatePassword().
      // TODO: Navigate to LoginScreen after successful update.
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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

                Text(
                  'Create a new password',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Gap.vMin,

                Text(
                  'Choose a new password for your account. '
                  'Make sure it is secure and easy for you to remember.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                Gap.vBreathing,

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // New password
                      AuthTextfield(
                        controller: _passwordController,
                        validator: _validatePassword,
                        onChanged: _onPasswordChanged,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.next,
                        inputDecoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'New Password',
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

                      // Password rules
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

                      // Confirm password
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

                Gap.vBreathing,

                AppButton(
                  label: 'Update Password',
                  isLoading: _isUpdating,
                  isEnabled: !_isUpdating,
                  onPressed: _onUpdatePasswordPressed,
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
