import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'time_zone.g.dart';

/// TimeZone
@JsonSerializable()
class TimeZone extends Equatable {
  /// Constructor for TimeZone
  const TimeZone({
    required this.location,
    required this.currentTime,
    required this.timezoneAbbreviation,
    required this.gmtOffset,
  });

  /// Converts a [Map<String, dynamic>] into a [TimeZone] instance.
  factory TimeZone.fromJson(Map<String, dynamic> json) =>
      _$TimeZoneFromJson(json);

  /// Converts a [TimeZone] instance into [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$TimeZoneToJson(this);

  /// Location name
  final String location;

  /// Current time for the location
  final DateTime currentTime;

  /// Time zone abbreviation
  final String timezoneAbbreviation;

  /// Time zone offset
  final double gmtOffset;

  @override
  List<Object> get props => [
        location,
        currentTime,
        timezoneAbbreviation,
        gmtOffset,
      ];

  /// CopyWith
  TimeZone copyWith({
    String? location,
    DateTime? currentTime,
    String? timezoneAbbreviation,
    double? gmtOffset,
  }) {
    return TimeZone(
      location: location ?? this.location,
      currentTime: currentTime ?? this.currentTime,
      timezoneAbbreviation: timezoneAbbreviation ?? this.timezoneAbbreviation,
      gmtOffset: gmtOffset ?? this.gmtOffset,
    );
  }
}
