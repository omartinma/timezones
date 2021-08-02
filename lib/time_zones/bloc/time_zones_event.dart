part of 'time_zones_bloc.dart';

abstract class TimeZonesEvent extends Equatable {
  const TimeZonesEvent();
}

class TimeZonesFetchRequested extends TimeZonesEvent {
  const TimeZonesFetchRequested({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}
