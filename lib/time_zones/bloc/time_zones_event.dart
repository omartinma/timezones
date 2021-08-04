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
