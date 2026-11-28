import 'package:bloom/core/router/routes.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/auth/data/models/auth_state.dart';
import 'package:bloom/features/auth/presentation/providers/auth_controller.dart';
import 'package:bloom/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:bloom/features/auth/presentation/widgets/logo_and_tagline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isEmailValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // EMAIL

  void _onEmailChanged(String value) {
    setState(() {
      _isEmailValid =
          value.trim().isNotEmpty &&
          RegExp(r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$').hasMatch(value.trim());
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$').hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  Color _emailBorderColor(ColorScheme colors, {bool focused = false}) {
    if (_emailController.text.isEmpty) {
      return focused ? colors.primary : colors.outlineVariant;
    }

    return _isEmailValid ? Colors.green : colors.error;
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.feature),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  // PASSWORD RESET

  Future<void> _onSendPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();

    await ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(email: email);

    if (!mounted) return;

    final authState = ref.read(authControllerProvider);

    final emailSent = authState.maybeWhen(
      passwordResetEmailSent: (_) => true,
      orElse: () => false,
    );

    if (emailSent) {
      context.push(Routes.resetPasswordScreen, extra: email);
    }
  }

  void _onBackToLoginPressed() {
    context.go(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        authError: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: colors.error),
          );
        },
        orElse: () {},
      );
    });

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoAndTagline(
                  logoUrl: 'assets/images/bloom_logo.svg',
                  tagline: 'A little more supported, every step of the way',
                ),

                const SizedBox(height: AppSpacing.breathing),

                Text(
                  'Forgot password?',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Gap.vMin,

                Text(
                  'It happens. Enter the email address associated '
                  'with your account and we will send you a link '
                  'to reset your password.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                Gap.vBreathing,

                Form(
                  key: _formKey,
                  child: AuthTextfield(
                    controller: _emailController,
                    validator: _validateEmail,
                    onChanged: _onEmailChanged,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
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
                ),

                Gap.vBreathing,

                AppButton(
                  label: 'Send Reset Link',
                  isLoading: isLoading,
                  isEnabled: !isLoading,
                  onPressed: _onSendPressed,
                ),

                Gap.vGroup,

                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : _onBackToLoginPressed,
                    child: Text(
                      'Back to Log In',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
