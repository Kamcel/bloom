// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserAuth {

 String get id; String get name; String get email; DateTime? get createdAt; DateTime? get emailVerifiedAt;
/// Create a copy of UserAuth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAuthCopyWith<UserAuth> get copyWith => _$UserAuthCopyWithImpl<UserAuth>(this as UserAuth, _$identity);

  /// Serializes this UserAuth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserAuth;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAuth&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.emailVerifiedAt, _this.emailVerifiedAt) || other.emailVerifiedAt == _this.emailVerifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserAuth;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.createdAt,_this.emailVerifiedAt);
}

@override
String toString() {
  final _this = this as UserAuth;
  return 'UserAuth(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, createdAt: ${_this.createdAt}, emailVerifiedAt: ${_this.emailVerifiedAt})';
}


}

/// @nodoc
abstract mixin class $UserAuthCopyWith<$Res>  {
  factory $UserAuthCopyWith(UserAuth value, $Res Function(UserAuth) _then) = _$UserAuthCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, DateTime? createdAt, DateTime? emailVerifiedAt
});




}
/// @nodoc
class _$UserAuthCopyWithImpl<$Res>
    implements $UserAuthCopyWith<$Res> {
  _$UserAuthCopyWithImpl(this._self, this._then);

  final UserAuth _self;
  final $Res Function(UserAuth) _then;

/// Create a copy of UserAuth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? createdAt = freezed,Object? emailVerifiedAt = freezed,}) {
  return _then(UserAuth(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAuth].
extension UserAuthPatterns on UserAuth {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAuth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAuth() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAuth value)  $default,){
final _that = this;
switch (_that) {
case _UserAuth():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAuth value)?  $default,){
final _that = this;
switch (_that) {
case _UserAuth() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  DateTime? createdAt,  DateTime? emailVerifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAuth() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.emailVerifiedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  DateTime? createdAt,  DateTime? emailVerifiedAt)  $default,) {final _that = this;
switch (_that) {
case _UserAuth():
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.emailVerifiedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  DateTime? createdAt,  DateTime? emailVerifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserAuth() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.emailVerifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAuth extends UserAuth {
  const _UserAuth({required this.id, required this.name, required this.email, this.createdAt, this.emailVerifiedAt}): super._();
  factory _UserAuth.fromJson(Map<String, dynamic> json) => _$UserAuthFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  DateTime? createdAt;
@override final  DateTime? emailVerifiedAt;

/// Create a copy of UserAuth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAuthCopyWith<_UserAuth> get copyWith => __$UserAuthCopyWithImpl<_UserAuth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAuthToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAuth&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,createdAt,emailVerifiedAt);
}

@override
String toString() {
    return 'UserAuth(id: $id, name: $name, email: $email, createdAt: $createdAt, emailVerifiedAt: $emailVerifiedAt)';
}


}

/// @nodoc
abstract mixin class _$UserAuthCopyWith<$Res> implements $UserAuthCopyWith<$Res> {
  factory _$UserAuthCopyWith(_UserAuth value, $Res Function(_UserAuth) _then) = __$UserAuthCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, DateTime? createdAt, DateTime? emailVerifiedAt
});




}
/// @nodoc
class __$UserAuthCopyWithImpl<$Res>
    implements _$UserAuthCopyWith<$Res> {
  __$UserAuthCopyWithImpl(this._self, this._then);

  final _UserAuth _self;
  final $Res Function(_UserAuth) _then;

/// Create a copy of UserAuth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? createdAt = freezed,Object? emailVerifiedAt = freezed,}) {
  return _then(_UserAuth(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
