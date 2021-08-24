import 'package:time_zone_repository/time_zone_repository.dart';

TimeZones createTimeZonesStub() {
  return TimeZones(items: [createTimeZoneStub()]);
}

TimeZone createTimeZoneStub({double? offset}) {
  return TimeZone(
    location: 'madrid',
    currentTime: currentTime,
    timezoneAbbreviation: 'CEST',
    gmtOffset: 0,
    offset: offset ?? 0,
  );
}

final currentTime = DateTime.now();
