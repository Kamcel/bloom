import 'package:bloom/features/auth/data/models/auth_state.dart';
import 'package:bloom/features/auth/data/repository/auth_repository.dart';
import 'package:bloom/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_state.dart';

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
}
