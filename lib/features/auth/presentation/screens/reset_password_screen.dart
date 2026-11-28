import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/auth/presentation/widgets/logo_and_tagline.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class ResetPasswordEmailSentScreen extends StatelessWidget {
  const ResetPasswordEmailSentScreen({super.key, required this.email});

  final String email;

  void _onBackToLoginPressed() {
    // TODO: Navigate to LoginScreen.
  }

  void _onResendPressed() {
    // TODO: Resend password reset email.
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

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.breathing),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.envelopeOpen,
                      color: colors.primary,
                      size: 48,
                    ),
                  ),
                ),

                Gap.vBreathing,

                Center(
                  child: Text(
                    'Check your email',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Gap.vMin,

                Center(
                  child: Text(
                    'We have sent a password reset link to:',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Gap.vMin,

                Center(
                  child: Text(
                    email,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Gap.vBreathing,

                Center(
                  child: Text(
                    'Open the link in your email to continue '
                    'resetting your password. If you cannot find '
                    'it, check your spam or junk folder.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Gap.vBreathing,

                AppButton(
                  label: 'Back to Log In',
                  isLoading: false,
                  isEnabled: true,
                  onPressed: _onBackToLoginPressed,
                ),

                Gap.vMin,

                Center(
                  child: TextButton(
                    onPressed: _onResendPressed,
                    child: Text(
                      'Resend email',
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
