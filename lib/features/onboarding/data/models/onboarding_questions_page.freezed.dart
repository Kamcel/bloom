// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_questions_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingQuestionsPage {

 String get title; String get subTitle;
/// Create a copy of OnboardingQuestionsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingQuestionsPageCopyWith<OnboardingQuestionsPage> get copyWith => _$OnboardingQuestionsPageCopyWithImpl<OnboardingQuestionsPage>(this as OnboardingQuestionsPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingQuestionsPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingQuestionsPage&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.subTitle, _this.subTitle) || other.subTitle == _this.subTitle));
}


@override
int get hashCode {
  final _this = this as OnboardingQuestionsPage;
  return Object.hash(runtimeType,_this.title,_this.subTitle);
}

@override
String toString() {
  final _this = this as OnboardingQuestionsPage;
  return 'OnboardingQuestionsPage(title: ${_this.title}, subTitle: ${_this.subTitle})';
}


}

/// @nodoc
abstract mixin class $OnboardingQuestionsPageCopyWith<$Res>  {
  factory $OnboardingQuestionsPageCopyWith(OnboardingQuestionsPage value, $Res Function(OnboardingQuestionsPage) _then) = _$OnboardingQuestionsPageCopyWithImpl;
@useResult
$Res call({
 String title, String subTitle
});




}
/// @nodoc
class _$OnboardingQuestionsPageCopyWithImpl<$Res>
    implements $OnboardingQuestionsPageCopyWith<$Res> {
  _$OnboardingQuestionsPageCopyWithImpl(this._self, this._then);

  final OnboardingQuestionsPage _self;
  final $Res Function(OnboardingQuestionsPage) _then;

/// Create a copy of OnboardingQuestionsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? subTitle = null,}) {
  return _then(OnboardingQuestionsPage(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingQuestionsPage].
extension OnboardingQuestionsPagePatterns on OnboardingQuestionsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingQuestionsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingQuestionsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingQuestionsPage value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingQuestionsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingQuestionsPage value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingQuestionsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String subTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingQuestionsPage() when $default != null:
return $default(_that.title,_that.subTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String subTitle)  $default,) {final _that = this;
switch (_that) {
case _OnboardingQuestionsPage():
return $default(_that.title,_that.subTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String subTitle)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingQuestionsPage() when $default != null:
return $default(_that.title,_that.subTitle);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingQuestionsPage extends OnboardingQuestionsPage {
  const _OnboardingQuestionsPage({required this.title, required this.subTitle}): super._();
  

@override final  String title;
@override final  String subTitle;

/// Create a copy of OnboardingQuestionsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingQuestionsPageCopyWith<_OnboardingQuestionsPage> get copyWith => __$OnboardingQuestionsPageCopyWithImpl<_OnboardingQuestionsPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingQuestionsPage&&(identical(other.title, title) || other.title == title)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,subTitle);
}

@override
String toString() {
    return 'OnboardingQuestionsPage(title: $title, subTitle: $subTitle)';
}


}

/// @nodoc
abstract mixin class _$OnboardingQuestionsPageCopyWith<$Res> implements $OnboardingQuestionsPageCopyWith<$Res> {
  factory _$OnboardingQuestionsPageCopyWith(_OnboardingQuestionsPage value, $Res Function(_OnboardingQuestionsPage) _then) = __$OnboardingQuestionsPageCopyWithImpl;
@override @useResult
$Res call({
 String title, String subTitle
});




}
/// @nodoc
class __$OnboardingQuestionsPageCopyWithImpl<$Res>
    implements _$OnboardingQuestionsPageCopyWith<$Res> {
  __$OnboardingQuestionsPageCopyWithImpl(this._self, this._then);

  final _OnboardingQuestionsPage _self;
  final $Res Function(_OnboardingQuestionsPage) _then;

/// Create a copy of OnboardingQuestionsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? subTitle = null,}) {
  return _then(_OnboardingQuestionsPage(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
