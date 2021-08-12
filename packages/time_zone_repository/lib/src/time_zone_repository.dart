import 'dart:async';
import 'dart:convert';

import 'package:instant/instant.dart';
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
  Future<TimeZone> getTimeZoneForLocation(String query) async {
    final location = await _locationApi.locationSearch(query);
    final timeZoneApiResponse = await _timeZoneApi.getTimeZone(
      location.latLng.longitude,
      location.latLng.latitude,
    );
    return TimeZone(
      location: location.title,
      currentTime: timeZoneApiResponse.datetime,
      timezoneAbbreviation: timeZoneApiResponse.timezoneAbbreviation,
      gmtOffset: timeZoneApiResponse.gmtOffset,
    );
  }

  /// Returns [TimeZones]
  /// It will return the cache if any with the updated time
  Future<TimeZones> getTimeZones() async {
    final cachedTimeZonesJson = await _storage.read(key: _timeZoneCacheKey);

    /// If cache empty we return an empty instance
    if (cachedTimeZonesJson == null) {
      return _timeZones = const TimeZones();
    }

    /// We get the data from cache
    final cachedTimeZones = TimeZones.fromJson(
      jsonDecode(cachedTimeZonesJson) as Map<String, dynamic>,
    );
    _timeZones = cachedTimeZones;

    /// We update in memory for the current time
    final timeZonesItems = <TimeZone>[];
    for (final item in _timeZones.items) {
      final updatedTime = curDateTimeByUtcOffset(offset: item.gmtOffset);
      timeZonesItems.add(item.copyWith(currentTime: updatedTime));
    }
    _timeZones = _timeZones.copyWith(items: timeZonesItems);

    /// Refresh cache
    await _refreshCache();

    return timeZones;
  }

  /// Add a new [TimeZone] and return the last updated [TimeZones]
  /// for a selected time
  Future<TimeZones> addTimeZone(String query, DateTime timeSelected) async {
    final newTimeZone = await getTimeZoneForLocation(query);
    final convertedTime = dateTimeToOffset(
      offset: newTimeZone.gmtOffset,
      datetime: timeSelected.toUtc(),
    );

    final newItems = [
      ..._timeZones.items,
      newTimeZone.copyWith(currentTime: convertedTime),
    ];
    _timeZones = TimeZones(items: newItems);
    await _refreshCache();
    return _timeZones;
  }

  /// Returns [TimeZones] updated for a given [timeSelected]
  TimeZones convertTimeZones(
    TimeZones timeZones,
    DateTime timeSelected,
  ) {
    final newItems = <TimeZone>[];
    for (final timeZone in timeZones.items) {
      final convertedTime = dateTimeToOffset(
        offset: timeZone.gmtOffset,
        datetime: timeSelected.toUtc(),
      );

      final newTimeZone = timeZone.copyWith(currentTime: convertedTime);
      newItems.add(newTimeZone);
    }
    return _timeZones = TimeZones(items: newItems);
  }

  /// Add a new [TimeZone] and return the last updated [TimeZones]
  /// for a selected time
  Future<TimeZones> deleteTimeZone(TimeZone timeZone) async {
    _timeZones = _timeZones.copyWith(
      items: List<TimeZone>.from(_timeZones.items)
        ..removeWhere((element) => element.location == timeZone.location),
    );
    await _refreshCache();
    return _timeZones;
  }

  Future<void> _refreshCache() async {
    await _storage.write(
      key: _timeZoneCacheKey,
      value: jsonEncode(_timeZones.toJson()),
    );
  }
}
