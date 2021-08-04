part of 'time_zones_bloc.dart';

enum TimeZonesStatus {
  loading,
  populated,
  error,
}

class TimeZonesState extends Equatable {
  const TimeZonesState({
    this.status = TimeZonesStatus.loading,
    this.timeZones = const TimeZones(),
  });

  final TimeZonesStatus status;
  final TimeZones timeZones;

  @override
  List<Object?> get props => [status, timeZones];

  TimeZonesState copyWith({
    TimeZonesStatus? status,
    TimeZones? timeZones,
  }) {
    return TimeZonesState(
      status: status ?? this.status,
      timeZones: timeZones ?? this.timeZones,
    );
  }
}
