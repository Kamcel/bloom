import 'package:bloom/features/auth/data/models/auth_state.dart';
import 'package:bloom/features/auth/data/repository/auth_repository.dart';
import 'package:bloom/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    ref.listen(authStateChangesProvider, (previous, next) {
      next.when(
        data: (authEvent) {
          final user = authEvent.user;

          if (authEvent.event == supabase.AuthChangeEvent.passwordRecovery) {
            if (user != null) {
              state = AuthState.passwordRecovery(user: user);
            } else {
              state = const AuthState.authError(
                'Password recovery session is unavailable.',
              );
            }
            return;
          }

          if (user == null) {
            state = const AuthState.unauthenticated();
          } else if (user.emailVerifiedAt == null) {
            state = const AuthState.emailVerificationPending(
              message: 'Please verify your email address',
            );
          } else {
            state = AuthState.authenticated(user: user);
          }
        },
        loading: () {
          state = const AuthState.authLoading();
        },
        error: (error, stackTrace) {
          state = AuthState.authError(error.toString());
        },
      );
    });

    return const AuthState.authInitial();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.authLoading();

    try {
      await _repo.signUp(name: name, email: email, password: password);

      state = const AuthState.emailVerificationPending(
        message: 'Please check your email to verify your account',
      );
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.authLoading();

    try {
      final user = await _repo.signIn(email: email, password: password);

      if (user.emailVerifiedAt == null) {
        await _repo.signOut();

        state = const AuthState.emailVerificationPending(
          message: 'Please verify your email before accessing Bloom',
        );
      } else {
        state = AuthState.authenticated(user: user);
      }
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthState.authLoading();

    try {
      await _repo.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    state = const AuthState.authLoading();

    try {
      await _repo.sendPasswordResetEmail(email: email);

      state = AuthState.passwordResetEmailSent(email: email);
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> resendConfirmationEmail({required String email}) async {
    state = const AuthState.authLoading();

    try {
      await _repo.sendEmailConfirmation(email: email);

      state = const AuthState.emailVerificationPending(
        message: 'A new confirmation email has been sent',
      );
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    state = const AuthState.authLoading();

    try {
      final user = await _repo.updatePassword(newPassword: newPassword);

      state = AuthState.authenticated(user: user);
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.authLoading();

    try {
      await _repo.signInWithGoogle();
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }
}
