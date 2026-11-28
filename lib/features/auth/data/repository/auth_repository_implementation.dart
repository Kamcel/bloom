import 'package:bloom/features/auth/data/models/auth_event.dart';
import 'package:bloom/features/auth/data/models/user_auth.dart';
import 'package:bloom/features/auth/data/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthRepositoryImplementation implements AuthRepository {
  final supabase.SupabaseClient _client;

  AuthRepositoryImplementation(this._client);

  UserAuth _mapUser(supabase.User user) {
    final metadata = user.userMetadata ?? {};

    final name =
        metadata['name'] ?? metadata['full_name'] ?? metadata['display-name'];

    if (name is! String || name.trim().isEmpty) {
      throw StateError('User name is missing from Supabase metadata');
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      throw StateError('User email is missing');
    }

    return UserAuth(
      id: user.id,
      name: name,
      email: email,
      createdAt: DateTime.tryParse(user.createdAt),
      emailVerifiedAt: user.emailConfirmedAt == null
          ? null
          : DateTime.tryParse(user.emailConfirmedAt!),
    );
  }

  @override
  Future<UserAuth> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
      emailRedirectTo: 'bloom://auth-callback',
    );

    final user = response.user;

    if (user == null) {
      throw StateError('Account creation returned no user');
    }

    return _mapUser(user);
  }

  @override
  Future<UserAuth> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw StateError('Login returned no user');
    }

    return _mapUser(user);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'bloom://auth-callback',
    );
  }

  @override
  Future<void> sendEmailConfirmation({required String email}) async {
    await _client.auth.resend(type: supabase.OtpType.signup, email: email);
  }

  @override
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      supabase.OAuthProvider.google,
      redirectTo: 'bloom://auth-callback',
    );
  }

  @override
  Future<UserAuth> updatePassword({required String newPassword}) async {
    final response = await _client.auth.updateUser(
      supabase.UserAttributes(password: newPassword),
    );

    final user = response.user;

    if (user == null) {
      throw StateError('Password update returned no user');
    }

    return _mapUser(user);
  }

  @override
  Future<UserAuth?> getCurrentUser() async {
    final user = _client.auth.currentUser;

    return user == null ? null : _mapUser(user);
  }

  @override
  Stream<AuthEvent> get authStateChanges {
    return _client.auth.onAuthStateChange.map((authState) {
      final supabaseUser = authState.session?.user;

      return AuthEvent(
        event: authState.event,
        user: supabaseUser == null ? null : _mapUser(supabaseUser),
      );
    });
  }
}
