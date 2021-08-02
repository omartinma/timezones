part of 'time_zones_bloc.dart';

enum TimeZonesStatus {
  loading,
  populated,
  error,
}

class TimeZonesState extends Equatable {
  const TimeZonesState({
    this.status = TimeZonesStatus.loading,
    this.timeZones = const [],
  });

  final TimeZonesStatus status;
  final List<TimeZone> timeZones;

  @override
  List<Object?> get props => [status, timeZones];

  TimeZonesState copyWith({
    TimeZonesStatus? status,
    List<TimeZone>? timeZones,
  }) {
    return TimeZonesState(
      status: status ?? this.status,
      timeZones: timeZones ?? this.timeZones,
    );
  }
}
