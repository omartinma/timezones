// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    title: json['title'] as String,
    latLng: LatLng.fromJson(json['latt_long'] as String),
    woeid: json['woeid'] as int,
  );
}
