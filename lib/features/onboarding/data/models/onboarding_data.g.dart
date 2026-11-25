// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingData _$OnboardingDataFromJson(Map<String, dynamic> json) =>
    _OnboardingData(
      name: json['name'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      datingMethod: $enumDecodeNullable(
        _$DatingMethodEnumMap,
        json['datingMethod'],
      ),
      estimatedDueDate: json['estimatedDueDate'] == null
          ? null
          : DateTime.parse(json['estimatedDueDate'] as String),
      lastMensuralPeriod: json['lastMensuralPeriod'] == null
          ? null
          : DateTime.parse(json['lastMensuralPeriod'] as String),
      pregnancyWeek: (json['pregnancyWeek'] as num?)?.toInt(),
      pregnancyDay: (json['pregnancyDay'] as num?)?.toInt(),
      isFirstPregnancy: json['isFirstPregnancy'] as bool?,
    );

Map<String, dynamic> _$OnboardingDataToJson(_OnboardingData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'datingMethod': _$DatingMethodEnumMap[instance.datingMethod],
      'estimatedDueDate': instance.estimatedDueDate?.toIso8601String(),
      'lastMensuralPeriod': instance.lastMensuralPeriod?.toIso8601String(),
      'pregnancyWeek': instance.pregnancyWeek,
      'pregnancyDay': instance.pregnancyDay,
      'isFirstPregnancy': instance.isFirstPregnancy,
    };

const _$DatingMethodEnumMap = {
  DatingMethod.lastMenstrualPeriod: 'lastMenstrualPeriod',
  DatingMethod.conceptionDate: 'conceptionDate',
  DatingMethod.ivfTransfer: 'ivfTransfer',
  DatingMethod.ultrasound: 'ultrasound',
  DatingMethod.knownDueDate: 'knownDueDate',
  DatingMethod.unknown: 'unknown',
  DatingMethod.providerConfirmed: 'providerConfirmed',
};
