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

  Future<void> updatePassword({required String newPassword});

  Future<void> signInWithGoogle();

  Future<UserAuth?> getCurrentUser();

  Stream<UserAuth?> get authStateChanges;
}
