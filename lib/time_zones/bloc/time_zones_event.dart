part of 'time_zones_bloc.dart';

abstract class TimeZonesEvent extends Equatable {
  const TimeZonesEvent();
}

class TimeZonesFetchRequested extends TimeZonesEvent {
  const TimeZonesFetchRequested();
  @override
  List<Object?> get props => [];
}

class TimeZonesAddRequested extends TimeZonesEvent {
  const TimeZonesAddRequested({required this.city});

  final String city;

  @override
  List<Object?> get props => [city];
}

class TimeZonesTimeSelected extends TimeZonesEvent {
  const TimeZonesTimeSelected({required this.time});

  final DateTime time;

  @override
  List<Object?> get props => [time];
}

class TimeZonesDeleteRequested extends TimeZonesEvent {
  const TimeZonesDeleteRequested({required this.timeZone});

  final TimeZone timeZone;

  @override
  List<Object?> get props => [timeZone];
}

class TimeZonesTimeZoneNameSelected extends TimeZonesEvent {
  const TimeZonesTimeZoneNameSelected({required this.timeZoneName});

  final String timeZoneName;

  @override
  List<Object?> get props => [timeZoneName];
}
