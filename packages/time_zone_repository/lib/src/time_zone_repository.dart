import 'dart:async';
import 'dart:convert';

import 'package:instant/instant.dart';
import 'package:location_api/location_api.dart';
import 'package:storage/storage.dart';
import 'package:time_zone_api/time_zone_api.dart';
import 'package:time_zone_repository/time_zone_repository.dart';

/// Exception thrown when trying to add a time zone that is added already
class DuplicatedTimeZoneException implements Exception {}

/// Exception thrown when trying to add a time zone that is not found
class NotFoundException implements Exception {}

/// {@template time_zone_repository}
/// Repository for time zone
/// {@endtemplate}
class TimeZoneRepository {
  /// {@macro time_zone_repository}

  TimeZoneRepository({
    required TimeZoneApi timeZoneApi,
    required LocationApi locationApi,
    required Storage storage,
    String? timeZoneName,
  })  : _timeZoneApi = timeZoneApi,
        _locationApi = locationApi,
        _storage = storage,
        timeZoneNameSelected = timeZoneName ?? DateTime.now().timeZoneName;

  final TimeZoneApi _timeZoneApi;
  final LocationApi _locationApi;
  final Storage _storage;
  static const _timeZoneCacheKey = '_timeZoneCacheKey';

  /// Exposes last updated list of [TimeZone]
  TimeZones get timeZones => _timeZones;
  TimeZones _timeZones = const TimeZones();

  /// Returns the offset for the current selected time zone
  double get offsetSelected => timeZoneOffsets[timeZoneNameSelected] ?? 0;

  /// Exposes last selected global time zone name
  String timeZoneNameSelected;

  /// Returns a [TimeZone] from a query based on location
  /// Throws [NotFoundException] if query is not found
  Future<TimeZone> getTimeZoneForLocation(String query) async {
    try {
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
        offset: timeZoneApiResponse.gmtOffset - offsetSelected,
      );
    } catch (_) {
      throw NotFoundException();
    }
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

    /// We update in memory for the current time
    final timeZonesItems = <TimeZone>[];
    for (final item in cachedTimeZones.items) {
      final updatedTime = curDateTimeByUtcOffset(offset: item.gmtOffset);
      timeZonesItems.add(item.copyWith(currentTime: updatedTime));
    }
    _timeZones = cachedTimeZones.copyWith(items: timeZonesItems);

    /// Refresh cache
    await _refreshCache();

    return timeZones;
  }

  /// Add a new [TimeZone] and return the last updated [TimeZones]
  /// for a selected time
  /// Throws [DuplicatedTimeZoneException] if this [TimeZone] exists already
  Future<TimeZones> addTimeZone(
    TimeZone newTimeZone,
    DateTime timeSelected,
  ) async {
    if (_existsTimeZone(newTimeZone)) {
      throw DuplicatedTimeZoneException();
    }
    final convertedTime = _convertDateTime(
      fromOffset: timeZoneOffsets[timeZoneNameSelected] ?? 0,
      toOffSet: newTimeZone.gmtOffset,
      time: timeSelected,
    );

    final newItems = List<TimeZone>.from(_timeZones.items)
      ..add(newTimeZone.copyWith(currentTime: convertedTime));

    _timeZones = _timeZones.copyWith(items: newItems);
    await _refreshCache();
    return _timeZones;
  }

  /// Returns [TimeZones] updated for a given [timeSelected]
  TimeZones convertTimeZones(TimeZones timeZones, DateTime timeSelected) {
    final newItems = <TimeZone>[];

    for (final timeZone in timeZones.items) {
      final convertedTime = _convertDateTime(
        fromOffset: timeZoneOffsets[timeZoneNameSelected] ?? 0,
        toOffSet: timeZone.gmtOffset,
        time: timeSelected,
      );

      final newTimeZone = timeZone.copyWith(currentTime: convertedTime);
      newItems.add(newTimeZone);
    }
    return _timeZones = _timeZones.copyWith(items: newItems);
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

  bool _existsTimeZone(TimeZone timeZone) {
    return _timeZones.items.any(
      (element) => element.location == timeZone.location,
    );
  }

  DateTime _convertDateTime({
    required double fromOffset,
    required double toOffSet,
    required DateTime time,
  }) {
    final offset = toOffSet - fromOffset;
    return time.add(Duration(hours: offset.toInt()));
  }
}
