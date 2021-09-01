part of 'live_clock_bloc.dart';

class LiveClockState extends Equatable {
  const LiveClockState({required this.time});

  final DateTime time;

  @override
  List<Object> get props => [time];

  LiveClockState copyWith({
    DateTime? time,
  }) {
    return LiveClockState(
      time: time ?? this.time,
    );
  }
}
