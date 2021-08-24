part of 'time_zones_bloc.dart';

enum TimeZonesStatus {
  loading,
  populated,
  error,
}

enum ErrorAddingStatus { duplicated, notFound }

class TimeZonesState extends Equatable {
  const TimeZonesState({
    this.status = TimeZonesStatus.loading,
    this.timeZones = const TimeZones(),
    this.timeSelected,
    this.errorAddingStatus,
    this.timeZoneName,
  });

  final TimeZonesStatus status;
  final TimeZones timeZones;
  final String? timeZoneName;
  final DateTime? timeSelected;
  final ErrorAddingStatus? errorAddingStatus;

  @override
  List<Object?> get props => [
        status,
        timeZones,
        timeSelected,
        errorAddingStatus,
        timeZoneName,
      ];

  TimeZonesState copyWith({
    TimeZonesStatus? status,
    TimeZones? timeZones,
    String? timeZoneName,
    DateTime? timeSelected,
    ErrorAddingStatus? errorAddingStatus,
  }) {
    return TimeZonesState(
      status: status ?? this.status,
      timeZones: timeZones ?? this.timeZones,
      timeZoneName: timeZoneName ?? this.timeZoneName,
      timeSelected: timeSelected ?? this.timeSelected,
      errorAddingStatus: errorAddingStatus ?? this.errorAddingStatus,
    );
  }
}
