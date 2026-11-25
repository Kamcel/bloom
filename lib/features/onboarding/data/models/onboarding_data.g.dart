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
      lastMenstrualPeriod: json['lastMenstrualPeriod'] == null
          ? null
          : DateTime.parse(json['lastMenstrualPeriod'] as String),
      cyclesRegular: json['cyclesRegular'] as bool?,
      cycleLengthDays: (json['cycleLengthDays'] as num?)?.toInt(),
      conceptionDate: json['conceptionDate'] == null
          ? null
          : DateTime.parse(json['conceptionDate'] as String),
      ivfTransferDate: json['ivfTransferDate'] == null
          ? null
          : DateTime.parse(json['ivfTransferDate'] as String),
      ivfEmbryoAgeDays: (json['ivfEmbryoAgeDays'] as num?)?.toInt(),
      ultrasoundDate: json['ultrasoundDate'] == null
          ? null
          : DateTime.parse(json['ultrasoundDate'] as String),
      ultrasoundGestationalWeeks: (json['ultrasoundGestationalWeeks'] as num?)
          ?.toInt(),
      ultrasoundGestationalDays: (json['ultrasoundGestationalDays'] as num?)
          ?.toInt(),
      knownDueDate: json['knownDueDate'] == null
          ? null
          : DateTime.parse(json['knownDueDate'] as String),
      providerConfirmedDueDate: json['providerConfirmedDueDate'] == null
          ? null
          : DateTime.parse(json['providerConfirmedDueDate'] as String),
      estimatedDueDate: json['estimatedDueDate'] == null
          ? null
          : DateTime.parse(json['estimatedDueDate'] as String),
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
      'lastMenstrualPeriod': instance.lastMenstrualPeriod?.toIso8601String(),
      'cyclesRegular': instance.cyclesRegular,
      'cycleLengthDays': instance.cycleLengthDays,
      'conceptionDate': instance.conceptionDate?.toIso8601String(),
      'ivfTransferDate': instance.ivfTransferDate?.toIso8601String(),
      'ivfEmbryoAgeDays': instance.ivfEmbryoAgeDays,
      'ultrasoundDate': instance.ultrasoundDate?.toIso8601String(),
      'ultrasoundGestationalWeeks': instance.ultrasoundGestationalWeeks,
      'ultrasoundGestationalDays': instance.ultrasoundGestationalDays,
      'knownDueDate': instance.knownDueDate?.toIso8601String(),
      'providerConfirmedDueDate': instance.providerConfirmedDueDate
          ?.toIso8601String(),
      'estimatedDueDate': instance.estimatedDueDate?.toIso8601String(),
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
