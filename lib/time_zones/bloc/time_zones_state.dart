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
    this.timeSelected,
  });

  final TimeZonesStatus status;
  final TimeZones timeZones;
  final DateTime? timeSelected;

  @override
  List<Object?> get props => [status, timeZones, timeSelected];

  TimeZonesState copyWith({
    TimeZonesStatus? status,
    TimeZones? timeZones,
    DateTime? timeSelected,
  }) {
    return TimeZonesState(
      status: status ?? this.status,
      timeZones: timeZones ?? this.timeZones,
      timeSelected: timeSelected ?? this.timeSelected,
    );
  }
}
