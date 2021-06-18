import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  const Location({
    required this.title,
    required this.latLng,
    required this.woeid,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  final String title;
  @JsonKey(name: 'latt_long')
  final LatLng latLng;
  final int woeid;
}

@JsonSerializable()
class LatLng {
  const LatLng({required this.latitude, required this.longitude});

  factory LatLng.fromJson(String? json) {
    final parts = json!.split(',');
    return LatLng(
      latitude: double.tryParse(parts[0]) ?? 0,
      longitude: double.tryParse(parts[1]) ?? 0,
    );
  }

  final double latitude;
  final double longitude;
}
