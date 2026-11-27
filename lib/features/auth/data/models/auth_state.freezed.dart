// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInitial value)?  authInitial,TResult Function( AuthLoading value)?  authLoading,TResult Function( Anauthenticated value)?  unauthenticated,TResult Function( Authenticated value)?  authenticated,TResult Function( EmailVerificationPending value)?  emailVerificationPending,TResult Function( PasswordResetEmailSent value)?  passwordResetEmailSent,TResult Function( PasswordRecovery value)?  passwordRecovery,TResult Function( AuthError value)?  authError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInitial() when authInitial != null:
return authInitial(_that);case AuthLoading() when authLoading != null:
return authLoading(_that);case Anauthenticated() when unauthenticated != null:
return unauthenticated(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case EmailVerificationPending() when emailVerificationPending != null:
return emailVerificationPending(_that);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case PasswordRecovery() when passwordRecovery != null:
return passwordRecovery(_that);case AuthError() when authError != null:
return authError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInitial value)  authInitial,required TResult Function( AuthLoading value)  authLoading,required TResult Function( Anauthenticated value)  unauthenticated,required TResult Function( Authenticated value)  authenticated,required TResult Function( EmailVerificationPending value)  emailVerificationPending,required TResult Function( PasswordResetEmailSent value)  passwordResetEmailSent,required TResult Function( PasswordRecovery value)  passwordRecovery,required TResult Function( AuthError value)  authError,}){
final _that = this;
switch (_that) {
case AuthInitial():
return authInitial(_that);case AuthLoading():
return authLoading(_that);case Anauthenticated():
return unauthenticated(_that);case Authenticated():
return authenticated(_that);case EmailVerificationPending():
return emailVerificationPending(_that);case PasswordResetEmailSent():
return passwordResetEmailSent(_that);case PasswordRecovery():
return passwordRecovery(_that);case AuthError():
return authError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInitial value)?  authInitial,TResult? Function( AuthLoading value)?  authLoading,TResult? Function( Anauthenticated value)?  unauthenticated,TResult? Function( Authenticated value)?  authenticated,TResult? Function( EmailVerificationPending value)?  emailVerificationPending,TResult? Function( PasswordResetEmailSent value)?  passwordResetEmailSent,TResult? Function( PasswordRecovery value)?  passwordRecovery,TResult? Function( AuthError value)?  authError,}){
final _that = this;
switch (_that) {
case AuthInitial() when authInitial != null:
return authInitial(_that);case AuthLoading() when authLoading != null:
return authLoading(_that);case Anauthenticated() when unauthenticated != null:
return unauthenticated(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case EmailVerificationPending() when emailVerificationPending != null:
return emailVerificationPending(_that);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case PasswordRecovery() when passwordRecovery != null:
return passwordRecovery(_that);case AuthError() when authError != null:
return authError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  authInitial,TResult Function()?  authLoading,TResult Function()?  unauthenticated,TResult Function( UserAuth user)?  authenticated,TResult Function( String message)?  emailVerificationPending,TResult Function( String email)?  passwordResetEmailSent,TResult Function( UserAuth user)?  passwordRecovery,TResult Function( String message)?  authError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInitial() when authInitial != null:
return authInitial();case AuthLoading() when authLoading != null:
return authLoading();case Anauthenticated() when unauthenticated != null:
return unauthenticated();case Authenticated() when authenticated != null:
return authenticated(_that.user);case EmailVerificationPending() when emailVerificationPending != null:
return emailVerificationPending(_that.message);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that.email);case PasswordRecovery() when passwordRecovery != null:
return passwordRecovery(_that.user);case AuthError() when authError != null:
return authError(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  authInitial,required TResult Function()  authLoading,required TResult Function()  unauthenticated,required TResult Function( UserAuth user)  authenticated,required TResult Function( String message)  emailVerificationPending,required TResult Function( String email)  passwordResetEmailSent,required TResult Function( UserAuth user)  passwordRecovery,required TResult Function( String message)  authError,}) {final _that = this;
switch (_that) {
case AuthInitial():
return authInitial();case AuthLoading():
return authLoading();case Anauthenticated():
return unauthenticated();case Authenticated():
return authenticated(_that.user);case EmailVerificationPending():
return emailVerificationPending(_that.message);case PasswordResetEmailSent():
return passwordResetEmailSent(_that.email);case PasswordRecovery():
return passwordRecovery(_that.user);case AuthError():
return authError(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  authInitial,TResult? Function()?  authLoading,TResult? Function()?  unauthenticated,TResult? Function( UserAuth user)?  authenticated,TResult? Function( String message)?  emailVerificationPending,TResult? Function( String email)?  passwordResetEmailSent,TResult? Function( UserAuth user)?  passwordRecovery,TResult? Function( String message)?  authError,}) {final _that = this;
switch (_that) {
case AuthInitial() when authInitial != null:
return authInitial();case AuthLoading() when authLoading != null:
return authLoading();case Anauthenticated() when unauthenticated != null:
return unauthenticated();case Authenticated() when authenticated != null:
return authenticated(_that.user);case EmailVerificationPending() when emailVerificationPending != null:
return emailVerificationPending(_that.message);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that.email);case PasswordRecovery() when passwordRecovery != null:
return passwordRecovery(_that.user);case AuthError() when authError != null:
return authError(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthInitial implements AuthState {
  const AuthInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.authInitial()';
}


}




/// @nodoc


class AuthLoading implements AuthState {
  const AuthLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.authLoading()';
}


}




/// @nodoc


class Anauthenticated implements AuthState {
  const Anauthenticated();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Anauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class Authenticated implements AuthState {
  const Authenticated({required this.user});
  

 final  UserAuth user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedCopyWith<Authenticated> get copyWith => _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Authenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user);
}

@override
String toString() {
    return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedCopyWith(Authenticated value, $Res Function(Authenticated) _then) = _$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserAuth user
});


$UserAuthCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(this._self, this._then);

  final Authenticated _self;
  final $Res Function(Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(Authenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserAuth,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserAuthCopyWith<$Res> get user {
  
  return $UserAuthCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class EmailVerificationPending implements AuthState {
  const EmailVerificationPending({required this.message});
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailVerificationPendingCopyWith<EmailVerificationPending> get copyWith => _$EmailVerificationPendingCopyWithImpl<EmailVerificationPending>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailVerificationPending&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthState.emailVerificationPending(message: $message)';
}


}

/// @nodoc
abstract mixin class $EmailVerificationPendingCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $EmailVerificationPendingCopyWith(EmailVerificationPending value, $Res Function(EmailVerificationPending) _then) = _$EmailVerificationPendingCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EmailVerificationPendingCopyWithImpl<$Res>
    implements $EmailVerificationPendingCopyWith<$Res> {
  _$EmailVerificationPendingCopyWithImpl(this._self, this._then);

  final EmailVerificationPending _self;
  final $Res Function(EmailVerificationPending) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(EmailVerificationPending(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordResetEmailSent implements AuthState {
  const PasswordResetEmailSent({required this.email});
  

 final  String email;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetEmailSentCopyWith<PasswordResetEmailSent> get copyWith => _$PasswordResetEmailSentCopyWithImpl<PasswordResetEmailSent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetEmailSent&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email);
}

@override
String toString() {
    return 'AuthState.passwordResetEmailSent(email: $email)';
}


}

/// @nodoc
abstract mixin class $PasswordResetEmailSentCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $PasswordResetEmailSentCopyWith(PasswordResetEmailSent value, $Res Function(PasswordResetEmailSent) _then) = _$PasswordResetEmailSentCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$PasswordResetEmailSentCopyWithImpl<$Res>
    implements $PasswordResetEmailSentCopyWith<$Res> {
  _$PasswordResetEmailSentCopyWithImpl(this._self, this._then);

  final PasswordResetEmailSent _self;
  final $Res Function(PasswordResetEmailSent) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(PasswordResetEmailSent(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordRecovery implements AuthState {
  const PasswordRecovery({required this.user});
  

 final  UserAuth user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordRecoveryCopyWith<PasswordRecovery> get copyWith => _$PasswordRecoveryCopyWithImpl<PasswordRecovery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordRecovery&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user);
}

@override
String toString() {
    return 'AuthState.passwordRecovery(user: $user)';
}


}

/// @nodoc
abstract mixin class $PasswordRecoveryCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $PasswordRecoveryCopyWith(PasswordRecovery value, $Res Function(PasswordRecovery) _then) = _$PasswordRecoveryCopyWithImpl;
@useResult
$Res call({
 UserAuth user
});


$UserAuthCopyWith<$Res> get user;

}
/// @nodoc
class _$PasswordRecoveryCopyWithImpl<$Res>
    implements $PasswordRecoveryCopyWith<$Res> {
  _$PasswordRecoveryCopyWithImpl(this._self, this._then);

  final PasswordRecovery _self;
  final $Res Function(PasswordRecovery) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(PasswordRecovery(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserAuth,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserAuthCopyWith<$Res> get user {
  
  return $UserAuthCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class AuthError implements AuthState {
  const AuthError(this.message);
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<AuthError> get copyWith => _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthState.authError(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) = _$AuthErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthErrorCopyWithImpl<$Res>
    implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
