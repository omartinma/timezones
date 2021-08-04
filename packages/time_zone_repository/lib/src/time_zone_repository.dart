import 'dart:async';

import 'package:location_api/location_api.dart';
import 'package:time_zone_api/time_zone_api.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

/// {@template time_zone_repository}
/// Repository for time zone
/// {@endtemplate}
class TimeZoneRepository {
  /// {@macro time_zone_repository}

  TimeZoneRepository({
    required TimeZoneApi timeZoneApi,
    required LocationApi locationApi,
  })  : _timeZoneApi = timeZoneApi,
        _locationApi = locationApi;

  final TimeZoneApi _timeZoneApi;
  final LocationApi _locationApi;

  /// Exposes last updated list of [TimeZone]
  List<TimeZone> get timeZones => _timeZones;
  final List<TimeZone> _timeZones = <TimeZone>[];

  /// Returns a [TimeZone] from a query based on location
  Future<TimeZone> getCurrentTimeForLocation(String query) async {
    final location = await _locationApi.locationSearch(query);
    final currentTime = await _timeZoneApi.getCurrentTime(
      location.latLng.longitude,
      location.latLng.latitude,
    );
    return TimeZone(location: location.title, currentTime: currentTime);
  }

  /// Returns list of [TimeZone]
  Future<List<TimeZone>> getTimeZones() async {
    return List.empty();
  }

  /// Add a new [TimeZone] and return the last updated list of [TimeZone]
  Future<List<TimeZone>> addTimeZone(String query) async {
    final newTimeZone = await getCurrentTimeForLocation(query);
    _timeZones.add(newTimeZone);
    return _timeZones;
  }
}
