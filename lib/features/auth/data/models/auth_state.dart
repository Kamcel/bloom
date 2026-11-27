import 'package:bloom/features/auth/data/models/user_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.authInitial() = AuthInitial;
  const factory AuthState.authLoading() = AuthLoading;
  const factory AuthState.unauthenticated() = Anauthenticated;
  const factory AuthState.authenticated({required UserAuth user}) =
      Authenticated;
  const factory AuthState.emailVerificationPending({required String message}) =
      EmailVerificationPending;
  const factory AuthState.passwordResetEmailSent({required String email}) =
      PasswordResetEmailSent;
  const factory AuthState.passwordRecovery({required UserAuth user}) =
      PasswordRecovery;
  const factory AuthState.authError(String message) = AuthError;
}
