import 'package:json_annotation/json_annotation.dart';

part 'time_zone_api_response.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)

/// Location
class TimeZoneApiResponse {
  /// Default constructor
  const TimeZoneApiResponse({
    required this.datetime,
    required this.timezoneAbbreviation,
    required this.gmtOffset,
  });

  /// Converts a [Map<String, dynamic>] into a [TimeZoneApiResponse] instance.
  factory TimeZoneApiResponse.fromJson(Map<String, dynamic> json) =>
      _$TimeZoneApiResponseFromJson(json);

  /// Current [DateTime] for the time zone
  final DateTime datetime;

  /// Time zone abbreviation
  final String timezoneAbbreviation;

  /// Time zone gmt offset
  final double gmtOffset;
}
