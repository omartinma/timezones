import 'dart:async';
import 'dart:convert';

import 'package:location_api/location_api.dart';
import 'package:storage/storage.dart';
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
    required Storage storage,
  })  : _timeZoneApi = timeZoneApi,
        _locationApi = locationApi,
        _storage = storage;

  final TimeZoneApi _timeZoneApi;
  final LocationApi _locationApi;
  final Storage _storage;
  static const _timeZoneCacheKey = '_timeZoneCacheKey';

  /// Exposes last updated list of [TimeZone]
  TimeZones get timeZones => _timeZones;
  TimeZones _timeZones = const TimeZones();

  /// Returns a [TimeZone] from a query based on location
  Future<TimeZone> getCurrentTimeForLocation(String query) async {
    final location = await _locationApi.locationSearch(query);
    final timeZoneApiResponse = await _timeZoneApi.getTimeZone(
      location.latLng.longitude,
      location.latLng.latitude,
    );
    return TimeZone(
      location: location.title,
      currentTime: timeZoneApiResponse.datetime,
      timezoneAbbreviation: timeZoneApiResponse.timezoneAbbreviation,
    );
  }

  /// Returns [TimeZones]
  Future<TimeZones> getTimeZones() async {
    if (_timeZones.items.isEmpty) {
      final cachedTimeZonesJson = await _storage.read(key: _timeZoneCacheKey);
      if (cachedTimeZonesJson == null) return timeZones;
      final cachedTimeZones = TimeZones.fromJson(
        jsonDecode(cachedTimeZonesJson) as Map<String, dynamic>,
      );
      _timeZones = cachedTimeZones;
    }
    return timeZones;
  }

  /// Add a new [TimeZone] and return the last updated [TimeZones]
  Future<TimeZones> addTimeZone(String query) async {
    final newTimeZone = await getCurrentTimeForLocation(query);
    final newItems = [..._timeZones.items, newTimeZone];
    _timeZones = TimeZones(items: newItems);
    await _storage.write(
      key: _timeZoneCacheKey,
      value: jsonEncode(_timeZones.toJson()),
    );
    return _timeZones;
  }
}
