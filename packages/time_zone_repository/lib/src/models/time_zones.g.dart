// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'time_zones.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZones _$TimeZonesFromJson(Map<String, dynamic> json) {
  return TimeZones(
    items: (json['items'] as List<dynamic>)
        .map((e) => TimeZone.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TimeZonesToJson(TimeZones instance) => <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
