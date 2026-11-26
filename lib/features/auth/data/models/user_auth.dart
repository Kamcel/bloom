import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_auth.freezed.dart';
part 'user_auth.g.dart';

// E -- Entity: UserAuth represents a description
@freezed
abstract class UserAuth with _$UserAuth {
  const UserAuth._();

  const factory UserAuth({
    required String id,
    required String name,
    required String email,
    DateTime? createdAt,
    DateTime? emailVerifiedAt,
  }) = _UserAuth;

  factory UserAuth.fromJson(Map<String, dynamic> json) =>
      _$UserAuthFromJson(json);
}
