
import 'package:bloom/core/router/routes.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_responsiveness.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bloom/features/auth/presentation/providers/auth_providers.dart';
import 'package:bloom/features/onboarding/data/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  bool _didNavigate = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (context.reduceMotion) {
        _controller.value = 1.0;
      } else {
        _controller.forward();
      }

      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    if (_isInitializing || _didNavigate) return;

    _isInitializing = true;

    try {
      // Allow an incoming password-recovery event to be processed.
      final authState = ref.read(authControllerProvider);

      final isRecovering = authState.maybeWhen(
        passwordRecovery: (_) => true,
        orElse: () => false,
      );

      if (isRecovering) {
        _navigate(Routes.createNewPasswordScreen);
        return;
      }

      // Check the existing Supabase session.
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.getCurrentUser();

      if (!mounted || _didNavigate) return;

      if (user != null) {
        if (user.emailVerifiedAt != null) {
          _navigate(Routes.homeScreen);
        } else {
          _navigate(Routes.loginScreen);
        }
        return;
      }

      // No authenticated session: check local onboarding completion.
      final onboardingRepository = ref.read(onboardingRepositoryProvider);

      final onboardingCompleted =
          await onboardingRepository.isOnboardingCompleted();

      if (!mounted || _didNavigate) return;

      _navigate(
        onboardingCompleted ? Routes.loginScreen : Routes.welcome1,
      );
    } catch (error, stackTrace) {
      debugPrint('App initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted || _didNavigate) return;

      // Safe fallback when startup checks fail.
      _navigate(Routes.loginScreen);
    }
  }

  void _navigate(String route) {
    if (!mounted || _didNavigate) return;

    _didNavigate = true;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      next.maybeWhen(
        passwordRecovery: (_) {
          _navigate(Routes.createNewPasswordScreen);
        },
        orElse: () {},
      );
    });

    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SvgPicture.asset(
              'assets/images/bloom_logo.svg',
              // Retain your original logo asset and sizing here.
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
