// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAuth _$UserAuthFromJson(Map<String, dynamic> json) => _UserAuth(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  emailVerifiedAt: json['emailVerifiedAt'] == null
      ? null
      : DateTime.parse(json['emailVerifiedAt'] as String),
);

Map<String, dynamic> _$UserAuthToJson(_UserAuth instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'createdAt': instance.createdAt?.toIso8601String(),
  'emailVerifiedAt': instance.emailVerifiedAt?.toIso8601String(),
};
