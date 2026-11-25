// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingData {

 String? get name; DateTime? get dateOfBirth; String? get country; String? get state; String? get city; DatingMethod? get datingMethod; DateTime? get estimatedDueDate; DateTime? get lastMensuralPeriod; int? get pregnancyWeek; int? get pregnancyDay; bool? get isFirstPregnancy;
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<OnboardingData> get copyWith => _$OnboardingDataCopyWithImpl<OnboardingData>(this as OnboardingData, _$identity);

  /// Serializes this OnboardingData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingData&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.datingMethod, _this.datingMethod) || other.datingMethod == _this.datingMethod)&&(identical(other.estimatedDueDate, _this.estimatedDueDate) || other.estimatedDueDate == _this.estimatedDueDate)&&(identical(other.lastMensuralPeriod, _this.lastMensuralPeriod) || other.lastMensuralPeriod == _this.lastMensuralPeriod)&&(identical(other.pregnancyWeek, _this.pregnancyWeek) || other.pregnancyWeek == _this.pregnancyWeek)&&(identical(other.pregnancyDay, _this.pregnancyDay) || other.pregnancyDay == _this.pregnancyDay)&&(identical(other.isFirstPregnancy, _this.isFirstPregnancy) || other.isFirstPregnancy == _this.isFirstPregnancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingData;
  return Object.hash(runtimeType,_this.name,_this.dateOfBirth,_this.country,_this.state,_this.city,_this.datingMethod,_this.estimatedDueDate,_this.lastMensuralPeriod,_this.pregnancyWeek,_this.pregnancyDay,_this.isFirstPregnancy);
}

@override
String toString() {
  final _this = this as OnboardingData;
  return 'OnboardingData(name: ${_this.name}, dateOfBirth: ${_this.dateOfBirth}, country: ${_this.country}, state: ${_this.state}, city: ${_this.city}, datingMethod: ${_this.datingMethod}, estimatedDueDate: ${_this.estimatedDueDate}, lastMensuralPeriod: ${_this.lastMensuralPeriod}, pregnancyWeek: ${_this.pregnancyWeek}, pregnancyDay: ${_this.pregnancyDay}, isFirstPregnancy: ${_this.isFirstPregnancy})';
}


}

/// @nodoc
abstract mixin class $OnboardingDataCopyWith<$Res>  {
  factory $OnboardingDataCopyWith(OnboardingData value, $Res Function(OnboardingData) _then) = _$OnboardingDataCopyWithImpl;
@useResult
$Res call({
 String? name, DateTime? dateOfBirth, String? country, String? state, String? city, DatingMethod? datingMethod, DateTime? estimatedDueDate, DateTime? lastMensuralPeriod, int? pregnancyWeek, int? pregnancyDay, bool? isFirstPregnancy
});




}
/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._self, this._then);

  final OnboardingData _self;
  final $Res Function(OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? dateOfBirth = freezed,Object? country = freezed,Object? state = freezed,Object? city = freezed,Object? datingMethod = freezed,Object? estimatedDueDate = freezed,Object? lastMensuralPeriod = freezed,Object? pregnancyWeek = freezed,Object? pregnancyDay = freezed,Object? isFirstPregnancy = freezed,}) {
  return _then(OnboardingData(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,datingMethod: freezed == datingMethod ? _self.datingMethod : datingMethod // ignore: cast_nullable_to_non_nullable
as DatingMethod?,estimatedDueDate: freezed == estimatedDueDate ? _self.estimatedDueDate : estimatedDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMensuralPeriod: freezed == lastMensuralPeriod ? _self.lastMensuralPeriod : lastMensuralPeriod // ignore: cast_nullable_to_non_nullable
as DateTime?,pregnancyWeek: freezed == pregnancyWeek ? _self.pregnancyWeek : pregnancyWeek // ignore: cast_nullable_to_non_nullable
as int?,pregnancyDay: freezed == pregnancyDay ? _self.pregnancyDay : pregnancyDay // ignore: cast_nullable_to_non_nullable
as int?,isFirstPregnancy: freezed == isFirstPregnancy ? _self.isFirstPregnancy : isFirstPregnancy // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingData].
extension OnboardingDataPatterns on OnboardingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingData value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingData value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  DateTime? dateOfBirth,  String? country,  String? state,  String? city,  DatingMethod? datingMethod,  DateTime? estimatedDueDate,  DateTime? lastMensuralPeriod,  int? pregnancyWeek,  int? pregnancyDay,  bool? isFirstPregnancy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.name,_that.dateOfBirth,_that.country,_that.state,_that.city,_that.datingMethod,_that.estimatedDueDate,_that.lastMensuralPeriod,_that.pregnancyWeek,_that.pregnancyDay,_that.isFirstPregnancy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  DateTime? dateOfBirth,  String? country,  String? state,  String? city,  DatingMethod? datingMethod,  DateTime? estimatedDueDate,  DateTime? lastMensuralPeriod,  int? pregnancyWeek,  int? pregnancyDay,  bool? isFirstPregnancy)  $default,) {final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that.name,_that.dateOfBirth,_that.country,_that.state,_that.city,_that.datingMethod,_that.estimatedDueDate,_that.lastMensuralPeriod,_that.pregnancyWeek,_that.pregnancyDay,_that.isFirstPregnancy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  DateTime? dateOfBirth,  String? country,  String? state,  String? city,  DatingMethod? datingMethod,  DateTime? estimatedDueDate,  DateTime? lastMensuralPeriod,  int? pregnancyWeek,  int? pregnancyDay,  bool? isFirstPregnancy)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.name,_that.dateOfBirth,_that.country,_that.state,_that.city,_that.datingMethod,_that.estimatedDueDate,_that.lastMensuralPeriod,_that.pregnancyWeek,_that.pregnancyDay,_that.isFirstPregnancy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingData extends OnboardingData {
  const _OnboardingData({this.name, this.dateOfBirth, this.country, this.state, this.city, this.datingMethod, this.estimatedDueDate, this.lastMensuralPeriod, this.pregnancyWeek, this.pregnancyDay, this.isFirstPregnancy}): super._();
  factory _OnboardingData.fromJson(Map<String, dynamic> json) => _$OnboardingDataFromJson(json);

@override final  String? name;
@override final  DateTime? dateOfBirth;
@override final  String? country;
@override final  String? state;
@override final  String? city;
@override final  DatingMethod? datingMethod;
@override final  DateTime? estimatedDueDate;
@override final  DateTime? lastMensuralPeriod;
@override final  int? pregnancyWeek;
@override final  int? pregnancyDay;
@override final  bool? isFirstPregnancy;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDataCopyWith<_OnboardingData> get copyWith => __$OnboardingDataCopyWithImpl<_OnboardingData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingData&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state)&&(identical(other.city, city) || other.city == city)&&(identical(other.datingMethod, datingMethod) || other.datingMethod == datingMethod)&&(identical(other.estimatedDueDate, estimatedDueDate) || other.estimatedDueDate == estimatedDueDate)&&(identical(other.lastMensuralPeriod, lastMensuralPeriod) || other.lastMensuralPeriod == lastMensuralPeriod)&&(identical(other.pregnancyWeek, pregnancyWeek) || other.pregnancyWeek == pregnancyWeek)&&(identical(other.pregnancyDay, pregnancyDay) || other.pregnancyDay == pregnancyDay)&&(identical(other.isFirstPregnancy, isFirstPregnancy) || other.isFirstPregnancy == isFirstPregnancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,dateOfBirth,country,state,city,datingMethod,estimatedDueDate,lastMensuralPeriod,pregnancyWeek,pregnancyDay,isFirstPregnancy);
}

@override
String toString() {
    return 'OnboardingData(name: $name, dateOfBirth: $dateOfBirth, country: $country, state: $state, city: $city, datingMethod: $datingMethod, estimatedDueDate: $estimatedDueDate, lastMensuralPeriod: $lastMensuralPeriod, pregnancyWeek: $pregnancyWeek, pregnancyDay: $pregnancyDay, isFirstPregnancy: $isFirstPregnancy)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDataCopyWith<$Res> implements $OnboardingDataCopyWith<$Res> {
  factory _$OnboardingDataCopyWith(_OnboardingData value, $Res Function(_OnboardingData) _then) = __$OnboardingDataCopyWithImpl;
@override @useResult
$Res call({
 String? name, DateTime? dateOfBirth, String? country, String? state, String? city, DatingMethod? datingMethod, DateTime? estimatedDueDate, DateTime? lastMensuralPeriod, int? pregnancyWeek, int? pregnancyDay, bool? isFirstPregnancy
});




}
/// @nodoc
class __$OnboardingDataCopyWithImpl<$Res>
    implements _$OnboardingDataCopyWith<$Res> {
  __$OnboardingDataCopyWithImpl(this._self, this._then);

  final _OnboardingData _self;
  final $Res Function(_OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? dateOfBirth = freezed,Object? country = freezed,Object? state = freezed,Object? city = freezed,Object? datingMethod = freezed,Object? estimatedDueDate = freezed,Object? lastMensuralPeriod = freezed,Object? pregnancyWeek = freezed,Object? pregnancyDay = freezed,Object? isFirstPregnancy = freezed,}) {
  return _then(_OnboardingData(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,datingMethod: freezed == datingMethod ? _self.datingMethod : datingMethod // ignore: cast_nullable_to_non_nullable
as DatingMethod?,estimatedDueDate: freezed == estimatedDueDate ? _self.estimatedDueDate : estimatedDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMensuralPeriod: freezed == lastMensuralPeriod ? _self.lastMensuralPeriod : lastMensuralPeriod // ignore: cast_nullable_to_non_nullable
as DateTime?,pregnancyWeek: freezed == pregnancyWeek ? _self.pregnancyWeek : pregnancyWeek // ignore: cast_nullable_to_non_nullable
as int?,pregnancyDay: freezed == pregnancyDay ? _self.pregnancyDay : pregnancyDay // ignore: cast_nullable_to_non_nullable
as int?,isFirstPregnancy: freezed == isFirstPregnancy ? _self.isFirstPregnancy : isFirstPregnancy // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
