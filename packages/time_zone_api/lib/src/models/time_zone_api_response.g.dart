// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_zone_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZoneApiResponse _$TimeZoneApiResponseFromJson(Map<String, dynamic> json) {
  return TimeZoneApiResponse(
    datetime: DateTime.parse(json['datetime'] as String),
    timezoneAbbreviation: json['timezone_abbreviation'] as String,
    gmtOffset: (json['gmt_offset'] as num).toDouble(),
  );
}
