part of 'time_zones_bloc.dart';

enum TimeZonesStatus {
  loading,
  populated,
  error,
}

class TimeZonesState extends Equatable {
  const TimeZonesState({required this.status, this.timeZone});

  final TimeZonesStatus status;
  final TimeZone? timeZone;

  @override
  List<Object?> get props => [status, timeZone];

  TimeZonesState copyWith({
    TimeZonesStatus? status,
    TimeZone? timeZone,
  }) {
    return TimeZonesState(
      status: status ?? this.status,
      timeZone: timeZone ?? this.timeZone,
    );
  }
}
