// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) {
  return TimeZone(
    location: json['location'] as String,
    currentTime: DateTime.parse(json['currentTime'] as String),
  );
}

Map<String, dynamic> _$TimeZoneToJson(TimeZone instance) => <String, dynamic>{
      'location': instance.location,
      'currentTime': instance.currentTime.toIso8601String(),
    };
