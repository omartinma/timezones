part of 'time_zones_bloc.dart';

abstract class TimeZonesEvent {
  const TimeZonesEvent();
}

class TimeZonesFetchRequested extends TimeZonesEvent {
  const TimeZonesFetchRequested();
}
