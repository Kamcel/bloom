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
