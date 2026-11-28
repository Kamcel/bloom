import 'package:bloom/core/router/routes.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/auth/data/models/auth_state.dart';
import 'package:bloom/features/auth/presentation/providers/auth_controller.dart';
import 'package:bloom/features/auth/presentation/widgets/logo_and_tagline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class ResetPasswordEmailSentScreen extends ConsumerWidget {
  const ResetPasswordEmailSentScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        authError: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        },
        passwordResetEmailSent: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reset email sent again.')),
          );
        },
        orElse: () {},
      );
    });

    final isSending = authState.maybeWhen(
      authLoading: () => true,
      orElse: () => false,
    );

    Future<void> resendEmail() async {
      await ref
          .read(authControllerProvider.notifier)
          .sendPasswordResetEmail(email: email);
    }

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
                  onPressed: () {
                    context.go(Routes.loginScreen);
                  },
                ),
                Gap.vMin,
                Center(
                  child: TextButton(
                    onPressed: isSending ? null : resendEmail,
                    child: Text(
                      isSending ? 'Sending...' : 'Resend email',
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
