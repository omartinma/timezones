import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

part 'time_zones.g.dart';

/// {@template time_zones}
/// [TimeZones] is a model representing all the [TimeZone] added
/// {@endtemplate}
@JsonSerializable()
class TimeZones extends Equatable {
  /// {@macro time_zones}
  const TimeZones({this.items = const []});

  /// Converts a [Map<String, dynamic>] into a [TimeZones] instance.
  factory TimeZones.fromJson(Map<String, dynamic> json) =>
      _$TimeZonesFromJson(json);

  /// Converts a [TimeZones] instance into [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$TimeZonesToJson(this);

  /// Items
  final List<TimeZone> items;

  @override
  List<Object> get props => [items];
}
