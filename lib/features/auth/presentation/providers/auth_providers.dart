import 'package:bloom/features/auth/data/models/auth_event.dart';
import 'package:bloom/features/auth/data/repository/auth_repository.dart';
import 'package:bloom/features/auth/data/repository/auth_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return AuthRepositoryImplementation(client);
});

final authStateChangesProvider = StreamProvider<AuthEvent>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return repository.authStateChanges;
});
