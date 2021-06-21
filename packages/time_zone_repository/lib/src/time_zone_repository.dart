import 'package:location_api/location_api.dart';
import 'package:time_zone_api/time_zone_api.dart';

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
}
