part of 'time_zones_bloc.dart';

enum TimeZonesStatus {
  loading,
  populated,
  error,
}

enum ErrorAddingStatus {
  duplicated,
}

class TimeZonesState extends Equatable {
  const TimeZonesState({
    this.status = TimeZonesStatus.loading,
    this.timeZones = const TimeZones(),
    this.timeSelected,
    this.errorAddingStatus,
  });

  final TimeZonesStatus status;
  final TimeZones timeZones;
  final DateTime? timeSelected;
  final ErrorAddingStatus? errorAddingStatus;

  @override
  List<Object?> get props => [
        status,
        timeZones,
        timeSelected,
        errorAddingStatus,
      ];

  TimeZonesState copyWith({
    TimeZonesStatus? status,
    TimeZones? timeZones,
    DateTime? timeSelected,
    ErrorAddingStatus? errorAddingStatus,
  }) {
    return TimeZonesState(
      status: status ?? this.status,
      timeZones: timeZones ?? this.timeZones,
      timeSelected: timeSelected ?? this.timeSelected,
      errorAddingStatus: errorAddingStatus ?? this.errorAddingStatus,
    );
  }
}
