part of 'live_clock_bloc.dart';

abstract class LiveClockEvent extends Equatable {
  const LiveClockEvent();

  @override
  List<Object> get props => [];
}

class LiveClockTimerEnded extends LiveClockEvent {
  const LiveClockTimerEnded();
}

class LiveClockTimerStarted extends LiveClockEvent {
  const LiveClockTimerStarted();
}
