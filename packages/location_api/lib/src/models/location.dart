import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()

/// Location
class Location {
  /// Default constructor
  const Location({
    required this.title,
    required this.latLng,
    required this.woeid,
  });

  /// Json deserialize
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  /// Name of the location
  final String title;
  @JsonKey(name: 'latt_long')

  /// Lat and long of the location
  final LatLng latLng;

  /// Id of the location
  final int woeid;
}

@JsonSerializable()

/// Lat and long of the location

class LatLng {
  /// Default constructor for LatLng
  const LatLng({required this.latitude, required this.longitude});

  /// Json deserialize
  factory LatLng.fromJson(String? json) {
    final parts = json!.split(',');
    return LatLng(
      latitude: double.tryParse(parts[0]) ?? 0,
      longitude: double.tryParse(parts[1]) ?? 0,
    );
  }

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;
}
