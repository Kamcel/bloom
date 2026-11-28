import 'package:bloom/features/auth/data/models/user_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthEvent {
  final supabase.AuthChangeEvent event;
  final UserAuth? user;

  const AuthEvent({required this.event, required this.user});
}
