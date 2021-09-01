part of 'live_clock_bloc.dart';

abstract class LiveClockEvent {
  const LiveClockEvent();
}

class LiveClockTimerEnded extends LiveClockEvent {
  const LiveClockTimerEnded();
}
