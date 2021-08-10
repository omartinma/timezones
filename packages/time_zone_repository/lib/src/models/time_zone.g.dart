// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'time_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) {
  return TimeZone(
    location: json['location'] as String,
    currentTime: DateTime.parse(json['currentTime'] as String),
    timezoneAbbreviation: json['timezoneAbbreviation'] as String,
    gmtOffset: (json['gmtOffset'] as num).toDouble(),
  );
}

Map<String, dynamic> _$TimeZoneToJson(TimeZone instance) => <String, dynamic>{
      'location': instance.location,
      'currentTime': instance.currentTime.toIso8601String(),
      'timezoneAbbreviation': instance.timezoneAbbreviation,
      'gmtOffset': instance.gmtOffset,
    };
