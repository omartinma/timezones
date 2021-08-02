import 'package:location_api/location_api.dart';
import 'package:time_zone_api/time_zone_api.dart';
import 'package:time_zone_repository/src/models/time_zone.dart';

/// {@template time_zone_repository}
/// Repository for time zone
/// {@endtemplate}
class TimeZoneRepository {
  /// {@macro time_zone_repository}

  TimeZoneRepository({
    TimeZoneApi? timeZoneApi,
    LocationApi? locationApi,
  })  : _timeZoneApi = timeZoneApi ?? TimeZoneApi(),
        _locationApi = locationApi ?? LocationApi();

  final TimeZoneApi _timeZoneApi;
  final LocationApi _locationApi;

  /// Returns a [TimeZone] from a query based on location

  Future<TimeZone> getCurrentTimeForLocation(String query) async {
    final location = await _locationApi.locationSearch(query);
    final currentTime = await _timeZoneApi.getCurrentTime(
      location.latLng.longitude,
      location.latLng.latitude,
    );
    return TimeZone(location: location.title, currentTime: currentTime);
  }
}
