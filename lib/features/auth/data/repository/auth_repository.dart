import 'package:bloom/features/auth/data/models/auth_event.dart';
import 'package:bloom/features/auth/data/models/user_auth.dart';

abstract class AuthRepository {
  Future<UserAuth> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<UserAuth> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> sendEmailConfirmation({required String email});

  Future<void> signInWithGoogle();

  Future<UserAuth> updatePassword({required String newPassword});

  Future<UserAuth?> getCurrentUser();

  Stream<AuthEvent> get authStateChanges;
}
