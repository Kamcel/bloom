import 'package:bloom/features/auth/data/models/auth_state.dart';
import 'package:bloom/features/auth/data/repository/auth_repository.dart';
import 'package:bloom/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  @override
  AuthState build() => const AuthState.authInitial();

  Future<void> initialize() async {
    state = const AuthState.authLoading();
    try {
      final user = await _repo.getCurrentUser();

      if (user == null) {
        state = const AuthState.unauthenticated();
      } else if (user.emailVerifiedAt == null) {
        state = const AuthState.emailVerificationPending(
          message: 'Please verify your email address',
        );
      } else {
        state = AuthState.authenticated(user: user);
      }
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
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
      state = AuthError(e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.authLoading();
    try {
      final user = await _repo.signIn(email: email, password: password);

      if (user.emailVerifiedAt == null) {
        await _repo.signOut();

        state = const AuthState.emailVerificationPending(
          message: 'This user doesn\'t exist. Please sign up',
        );
      } else {
        state = AuthState.authenticated(user: user);
      }
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();

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

      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> resendConfirmationEmail({required String email}) async {
    state = AuthState.authLoading();

    try {
      await _repo.sendEmailConfirmation(email: email);
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }

  Future<void> signInWIthGoogle() async {
    state = AuthState.authLoading();

    try {
      await _repo.signInWithGoogle();
    } catch (e) {
      state = AuthState.authError(e.toString());
    }
  }
}
