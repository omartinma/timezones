part of 'select_time_bloc.dart';

abstract class SelectTimeEvent extends Equatable {
  const SelectTimeEvent();
}

class SelectTimeSelected extends SelectTimeEvent {
  const SelectTimeSelected(this.time);

  final DateTime time;

  @override
  List<Object?> get props => [time];
}

class SelectTimeTimeZoneNameSelected extends SelectTimeEvent {
  const SelectTimeTimeZoneNameSelected(this.timeZoneName);

  final String timeZoneName;

  @override
  List<Object?> get props => [timeZoneName];
}
